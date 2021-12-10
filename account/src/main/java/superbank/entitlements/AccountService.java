package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

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

	@Bean
	public MockData mockData() {
		return new MockData();
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		mockData().initialize();
	}
}
