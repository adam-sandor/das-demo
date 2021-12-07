package superbank.entitlements.entities;

import org.apache.commons.lang3.builder.ToStringBuilder;

import javax.persistence.*;

@Entity
public class Account {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;

    private String iban;
    @ManyToOne
    private AccountHolder accountHolder;
    private String geoRegion;

    protected Account() {}

    public Account(String iban, AccountHolder accountHolder, String geoRegion) {
        this.iban = iban;
        this.accountHolder = accountHolder;
        this.geoRegion = geoRegion;
    }

    public String getIban() {
        return iban;
    }

    public AccountHolder getAccountHolder() {
        return accountHolder;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    public String getGeoRegion() {
        return geoRegion;
    }
}
