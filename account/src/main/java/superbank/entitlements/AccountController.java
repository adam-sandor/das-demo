package superbank.entitlements;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import superbank.entitlements.entities.Account;
import superbank.entitlements.entities.Transaction;
import superbank.entitlements.entities.TransactionResult;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static io.netty.util.internal.SystemPropertyUtil.contains;

@RestController
class AccountController {

	private final AccountRepository accountRepository;

	private final TransactionRepository transactionRepository;

	private static final Logger log = LoggerFactory.getLogger(AccountController.class);

	public AccountController(@Autowired AccountRepository accountRepository,
							 @Autowired TransactionRepository transactionRepository) {
		this.accountRepository = accountRepository;
		this.transactionRepository = transactionRepository;
	}

	@GetMapping("/account/{accountIban}/details")
	ResponseEntity<Account> accountDetails(@PathVariable(name = "accountIban") String accountIban,
										  @RequestHeader(name = "Authorization") String authHeader) {
		DecodedJWT jwt = JWT.decode(AuthHeader.getBearerToken(authHeader));
		//CS Level 1 and above can see account details
		List<String> roles = (List<String>) jwt.getClaim("realm_access").asMap().get("roles");
		if (!roles.contains("customer_support")
			|| jwt.getClaim("role_level").asInt() < 1) {
			return ResponseEntity.status(403).build();
		}

		Optional<Account> account = accountRepository.findAccountByIban(accountIban);
		if (account.isPresent()) {
			//CS of any level can only see accounts from their assigned geographic region
			if (account.get().getGeoRegion().equals(jwt.getClaim("geo_region").asString())) {
				return new ResponseEntity<>(account.get(), HttpStatus.OK);
			} else {
				return ResponseEntity.status(403).build();
			}
		} else {
			return ResponseEntity.notFound().build();
		}
	}

	@GetMapping("/account/{accountIban}/transactions")
	ResponseEntity<ObjectNode> accountTransactions(@PathVariable(name = "accountIban") String accountIban,
												   @RequestHeader(name = "Authorization") String authHeader) {
		DecodedJWT jwt = JWT.decode(AuthHeader.getBearerToken(authHeader));
		Optional<Account> account = accountRepository.findAccountByIban(accountIban);

		if (account.isPresent()) {
			if (!account.get().getGeoRegion().equals(jwt.getClaim("geo_region").asString())) {
				return ResponseEntity.status(403).body(errorNode("Account GEO_REGION doesn't match Support User's GEO_REGION"));
			}
		} else {
			return ResponseEntity.status(404).body(errorNode("Account " + accountIban + " not found"));
		}

		List<String> roles = (List<String>) jwt.getClaim("realm_access").asMap().get("roles");
		if (!roles.contains("customer_support")) {
			return ResponseEntity.status(403).build();
		}

        List<Transaction> dbTransactions = transactionRepository.findAllByAccountIban(accountIban, Sort.by(Sort.Direction.DESC, "timeStamp"));

		//CS Level 2 can see failed transactions
		//CS Level 3 can see all transactions
        List<Transaction> filteredTransactions = dbTransactions.stream().filter(t -> {
            if (jwt.getClaim("role_level").asInt() == 2) {
                return t.getResult() != TransactionResult.SUCCESS;
            } else if (jwt.getClaim("role_level").asInt() == 3) {
                return true;
            } else {
				return false;
			}
        }).collect(Collectors.toList());

        ObjectNode transactions = new ObjectMapper().createObjectNode();
        transactions.put("accountIban", accountIban);
        ArrayNode transactionList = transactions.putArray("transactionList");
        filteredTransactions.forEach(t -> {
            ObjectNode transaction = new ObjectMapper().createObjectNode();
            transaction.put("otherAccountIban", t.getOtherAccountIban());
            transaction.put("amount", t.getAmount());
            transaction.put("timeStamp", t.getTimeStamp().toString());
            transaction.put("type", t.getType().name());
            transaction.put("result", t.getResult().name());
            transactionList.add(transaction);
        });
        return new ResponseEntity<>(transactions, HttpStatus.OK);
	}

	private static ObjectNode errorNode(String error) {
		ObjectNode node = new ObjectMapper().createObjectNode();
		node.put("message", error);
		return node;
	}
}
