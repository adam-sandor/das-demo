package superbank.entitlements.entities;

import org.apache.commons.lang3.builder.ToStringBuilder;

import javax.persistence.*;
import java.time.Instant;

@Entity
public class Transaction {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;

    private String otherAccountIban;
    private Double amount;
    @ManyToOne
    private Account account;
    private Instant timeStamp;
    private TransactionType type;

    protected Transaction() {}

    public Transaction(String otherAccountIban, Double amount, Account account, Instant timeStamp, TransactionType type) {
        this.otherAccountIban = otherAccountIban;
        this.amount = amount;
        this.account = account;
        this.timeStamp = timeStamp;
        this.type = type;
    }

    public Long getId() {
        return id;
    }

    public String getOtherAccountIban() {
        return otherAccountIban;
    }

    public TransactionType getType() {
        return type;
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
