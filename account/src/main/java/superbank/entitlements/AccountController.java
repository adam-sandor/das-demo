package superbank.entitlements;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.bisnode.opa.client.OpaClient;
import com.bisnode.opa.client.query.QueryForDocumentRequest;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
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

import java.util.List;
import java.util.Optional;

@RestController
class AccountController {

	private final OpaClient opaClient;

	private final AccountRepository accountRepository;

	private final TransactionRepository transactionRepository;

	private static final Logger log = LoggerFactory.getLogger(AccountController.class);

	public AccountController(@Autowired OpaClient opaClient,
							 @Autowired AccountRepository accountRepository,
							 @Autowired TransactionRepository transactionRepository) {
		this.opaClient = opaClient;
		this.accountRepository = accountRepository;
		this.transactionRepository = transactionRepository;
	}

	@GetMapping("/account/v2/{accountIban}/details")
	ResponseEntity<Account> accountDetails(@PathVariable(name = "accountIban") String accountIban,
										  @RequestHeader(name = "Authorization") String authHeader) {
		DecodedJWT jwt = JWT.decode(AuthHeader.getBearerToken(authHeader));
		Optional<Account> account = accountRepository.findAccountByIban(accountIban);
		if (account.isPresent()) {
			if (authorizeAccountWithOpa(jwt, account.get())) {
				return new ResponseEntity<>(account.get(), HttpStatus.OK);
			} else {
				return ResponseEntity.status(403).build();
			}
		} else {
			return ResponseEntity.notFound().build();
		}
	}

	@GetMapping("/account/v2/{accountIban}/transactions")
	ResponseEntity<JsonNode> accountTransactions(@PathVariable(name = "accountIban") String accountIban,
												   @RequestHeader(name = "Authorization") String authHeader) {
		DecodedJWT jwt = JWT.decode(AuthHeader.getBearerToken(authHeader));
		Optional<Account> account = accountRepository.findAccountByIban(accountIban);

		if (!account.isPresent()) {
			return ResponseEntity.status(404).body(errorNode("Account " + accountIban + " not found"));
		}

        List<Transaction> dbTransactions = transactionRepository.findAllByAccountIban(accountIban, Sort.by(Sort.Direction.DESC, "timeStamp"));

        ObjectNode opaInput = createOpaInputWithAccountAndSubject(jwt, account.get());
        ArrayNode transactions = opaInput.putArray("transactions");
		dbTransactions.forEach(t -> {
            ObjectNode transaction = new ObjectMapper().createObjectNode();
            transaction.put("otherAccountIban", t.getOtherAccountIban());
            transaction.put("amount", t.getAmount());
            transaction.put("timeStamp", t.getTimeStamp().toString());
            transaction.put("type", t.getType().name());
            transaction.put("result", t.getResult().name());
			transactions.add(transaction);
        });
		QueryForDocumentRequest opaQuery = new QueryForDocumentRequest(opaInput, "policy/app");
		ObjectNode opaResult = opaClient.queryForDocument(opaQuery, ObjectNode.class);
		if (opaResult.get("deny").size() > 0) {
			return ResponseEntity.status(403).body(opaResult.get("deny"));
		} else {
			ObjectNode response = new ObjectMapper().createObjectNode();
			response.put("accountIban", accountIban);
			response.set("transactionList", opaResult.get("transactions"));
			return ResponseEntity.ok(response);
		}
	}

	private ObjectNode createOpaInputWithAccountAndSubject(DecodedJWT jwt, Account account) {
		ObjectNode input = new ObjectMapper().createObjectNode();
		ObjectNode subject = new ObjectMapper().createObjectNode();
		subject.put("sub", jwt.getClaim("sub").asString());
		subject.put("userId", jwt.getClaim("userId").asString());
		subject.put("role_level", jwt.getClaim("role_level").asInt());
		subject.put("geo_region", jwt.getClaim("geo_region").asString());
		input.set("subject", subject);

		ObjectNode accountNode = new ObjectMapper().createObjectNode();
		accountNode.put("iban", account.getIban());
		accountNode.put("geo_region", account.getGeoRegion());
		accountNode.putPOJO("account_holder", account.getAccountHolder());
		input.set("account", accountNode);

		List<String> roles = (List<String>) jwt.getClaim("realm_access").asMap().get("roles");
		ArrayNode rolesNode = new ObjectMapper().createArrayNode();
		roles.forEach(role -> rolesNode.add(role));
		subject.set("roles", rolesNode);
		return input;
	}

	private boolean authorizeAccountWithOpa(DecodedJWT jwt, Account account) {
		ObjectNode input = createOpaInputWithAccountAndSubject(jwt, account);
		QueryForDocumentRequest opaQuery = new QueryForDocumentRequest(input, "policy/app");
		ObjectNode opaResult = opaClient.queryForDocument(opaQuery, ObjectNode.class);

		JsonNode deny = opaResult.get("deny");
		if (deny.size() > 0) {
			for (int i = 0; i < deny.size(); i++) {
				log.info("OPA authz deny: {}", deny.get(i).asText());
			}
		}
		return deny.size() == 0;
	}

	private static ObjectNode errorNode(String error) {
		ObjectNode node = new ObjectMapper().createObjectNode();
		node.put("message", error);
		return node;
	}
}
