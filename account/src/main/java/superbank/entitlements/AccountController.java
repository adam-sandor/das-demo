package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
import com.bisnode.opa.client.query.QueryForDocumentRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.commons.lang3.RandomUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.stream.IntStream;

@RestController
class AccountController {

	private final OpaClient opaClient;

	private static final Logger log = LoggerFactory.getLogger(AccountController.class);

	public AccountController(@Autowired OpaClient opaClient) {
		this.opaClient = opaClient;
	}

	@GetMapping("/account/{accountId}/status")
	ResponseEntity<ObjectNode> accountStatus(@PathVariable(name = "accountId") String accountId) {
		ObjectNode accountStatus = new ObjectMapper().createObjectNode();
		accountStatus.put("accountId", accountId);
		accountStatus.put("status", "active");
		accountStatus.put("lastTransaction", LocalDateTime.of(2021, 11, 2, 14, 22, 40).toString());
		return new ResponseEntity<>(accountStatus, HttpStatus.OK);
	}

	@GetMapping("/account/{accountId}/transactions")
	ResponseEntity<ObjectNode> accountTransactions(@PathVariable(name = "accountId") String accountId) {
		ObjectNode transactions = new ObjectMapper().createObjectNode();
		transactions.put("accountId", accountId);
		ArrayNode transactionList = transactions.putArray("transactionList");
		IntStream.range(0, RandomUtils.nextInt(4, 10)).forEach(i -> {
			ObjectNode transaction = new ObjectMapper().createObjectNode();
			transaction.put("id", UUID.randomUUID().toString());
			transaction.put("fromAccount", "NLINGB000004354563456");
			transaction.put("toAccount", "GB444B000004354563456");
			transaction.put("amount", RandomUtils.nextInt(100, 5000));
			transactionList.add(transaction);
		});
		return new ResponseEntity<>(transactions, HttpStatus.OK);
	}
}
