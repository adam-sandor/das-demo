package superbank.entitlements;

import org.springframework.data.repository.CrudRepository;
import superbank.entitlements.entities.Account;
import superbank.entitlements.entities.AccountHolder;

public interface AccountHolderRepository extends CrudRepository<AccountHolder, Long> {
}
