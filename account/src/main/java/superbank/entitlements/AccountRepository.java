package superbank.entitlements;

import org.springframework.data.repository.CrudRepository;
import superbank.entitlements.entities.Account;

public interface AccountRepository extends CrudRepository<Account, Long> {
}
