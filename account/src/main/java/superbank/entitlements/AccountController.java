package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
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
import org.springframework.web.bind.annotation.RestController;
import superbank.entitlements.entities.Account;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.IntStream;

@RestController
class AccountController {

	private final OpaClient opaClient;

	private final AccountRepository accountRepository;

	private final AccountHolderRepository accountHolderRepository;

	private static final Logger log = LoggerFactory.getLogger(AccountController.class);

	public AccountController(@Autowired OpaClient opaClient,
							 @Autowired AccountRepository accountRepository,
							 @Autowired AccountHolderRepository accountHolderRepository) {
		this.opaClient = opaClient;
		this.accountRepository = accountRepository;
		this.accountHolderRepository = accountHolderRepository;
	}

	@GetMapping("/account/{accountId}/status")
	ResponseEntity<Account> accountStatus(@PathVariable(name = "accountId") Long accountId) {
		Optional<Account> account = accountRepository.findById(accountId);
		if (account.isPresent()) {
			return new ResponseEntity<>(account.get(), HttpStatus.OK);
		} else {
			log.info("Account with ID {} not found", accountId);
			return ResponseEntity.notFound().build();
		}
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
