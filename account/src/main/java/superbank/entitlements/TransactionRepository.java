package superbank.entitlements;

import org.springframework.data.repository.CrudRepository;
import superbank.entitlements.entities.Account;
import superbank.entitlements.entities.Transaction;

import java.util.List;

public interface TransactionRepository extends CrudRepository<Transaction, Long> {

    List<Transaction> findAllByAccountIban(String accountIban);
}
