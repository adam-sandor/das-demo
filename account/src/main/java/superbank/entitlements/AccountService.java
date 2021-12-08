package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import superbank.entitlements.entities.Account;
import superbank.entitlements.entities.AccountHolder;
import superbank.entitlements.entities.Transaction;
import superbank.entitlements.entities.TransactionType;

import java.time.Instant;

import static superbank.entitlements.entities.TransactionType.OUTGOING;

@SpringBootApplication
public class AccountService implements ApplicationRunner {

	private static Logger log = LoggerFactory.getLogger(AccountService.class);

	public static void main(String... args) {
		SpringApplication.run(AccountService.class, args);
	}

	@Bean
	public OpaClient opaClient() {
		return OpaClient.builder().opaConfiguration("http://localhost:8181").build();
	}

	@Autowired
	private AccountRepository accountRepository;

	@Autowired
	private AccountHolderRepository accountHolderRepository;

	@Autowired
	private TransactionRepository transactionRepository;

	@Override
	public void run(ApplicationArguments args) throws Exception {
		log.info("Creating test data");
		AccountHolder adamSandor = accountHolderRepository.save(new AccountHolder("Adam Sandor", "Borgerstraat 143B, Amsterdam"));
		Account account1 = accountRepository.save(new Account("NL12345435345435345", adamSandor, "EU"));
		Account account2 = accountRepository.save(new Account("NL12345435345444444", adamSandor, "EU"));
		transactionRepository.save(new Transaction("SK54354656343444", 135.2, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444", 115.5, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444",  35.0, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444",  900.5, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444",  122.1, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444",  135.2, account1, Instant.now(), OUTGOING));
		transactionRepository.save(new Transaction("SK54354656343444",  135.2, account1, Instant.now(), OUTGOING));
	}
}
