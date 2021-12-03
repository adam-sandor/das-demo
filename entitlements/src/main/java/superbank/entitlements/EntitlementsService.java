package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class EntitlementsService {

	public static void main(String... args) {
		SpringApplication.run(EntitlementsService.class, args);
	}

	@Bean
	public OpaClient opaClient() {
		return OpaClient.builder().opaConfiguration("http://localhost:8181").build();
	}
}
