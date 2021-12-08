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
import superbank.entitlements.entities.Transaction;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.IntStream;

@RestController
class AccountController {

	private final OpaClient opaClient;

	private final AccountRepository accountRepository;

	private final AccountHolderRepository accountHolderRepository;

	private final TransactionRepository transactionRepository;

	private static final Logger log = LoggerFactory.getLogger(AccountController.class);

	public AccountController(@Autowired OpaClient opaClient,
							 @Autowired AccountRepository accountRepository,
							 @Autowired AccountHolderRepository accountHolderRepository,
							 @Autowired TransactionRepository transactionRepository) {
		this.opaClient = opaClient;
		this.accountRepository = accountRepository;
		this.accountHolderRepository = accountHolderRepository;
		this.transactionRepository = transactionRepository;
	}

	@GetMapping("/account/{accountIban}/status")
	ResponseEntity<Account> accountStatus(@PathVariable(name = "accountIban") String accountIban) {
		Optional<Account> account = accountRepository.findAccountByIban(accountIban);
		if (account.isPresent()) {
			return new ResponseEntity<>(account.get(), HttpStatus.OK);
		} else {
			return ResponseEntity.notFound().build();
		}
	}

	@GetMapping("/account/{accountIban}/transactions")
	ResponseEntity<ObjectNode> accountTransactions(@PathVariable(name = "accountIban") String accountIban) {
		List<Transaction> dbTransactions = transactionRepository.findAllByAccountIban(accountIban);

		ObjectNode transactions = new ObjectMapper().createObjectNode();
		transactions.put("accountIban", accountIban);
		ArrayNode transactionList = transactions.putArray("transactionList");
		dbTransactions.forEach(t -> {
			ObjectNode transaction = new ObjectMapper().createObjectNode();
			transaction.put("otherAccountIban", t.getOtherAccountIban());
			transaction.put("amount", t.getAmount());
			transaction.put("type", t.getType().name());
			transactionList.add(transaction);
		});
		return new ResponseEntity<>(transactions, HttpStatus.OK);
	}
}
