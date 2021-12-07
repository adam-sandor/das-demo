package superbank.entitlements.entities;

import org.apache.commons.lang3.builder.ToStringBuilder;

import javax.persistence.*;
import java.time.Instant;

@Entity
public class Transaction {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;

    private String sourceAccount;
    private String destinationAccount;
    private Double amount;
    @ManyToOne
    private Account account;
    private Instant timeStamp;

    protected Transaction() {}

    public Transaction(String sourceAccount, String destinationAccount, Double amount, Account account, Instant timeStamp) {
        this.sourceAccount = sourceAccount;
        this.destinationAccount = destinationAccount;
        this.amount = amount;
        this.account = account;
        this.timeStamp = timeStamp;
    }

    public Long getId() {
        return id;
    }

    public String getSourceAccount() {
        return sourceAccount;
    }

    public String getDestinationAccount() {
        return destinationAccount;
    }

    public Double getAmount() {
        return amount;
    }

    public Account getAccount() {
        return account;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    public Instant getTimeStamp() {
        return timeStamp;
    }
}
