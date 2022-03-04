package superbank.entitlements.entities;

import org.apache.commons.lang3.builder.ToStringBuilder;

import javax.persistence.*;

@Entity
public class Account {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Long id;

    protected String iban;
    private Long accountHolderId;
    protected String geoRegion;

    protected Account() {}

    public Account(String iban, long accountHolderId, String geoRegion) {
        this.iban = iban;
        this.accountHolderId = new Long(accountHolderId);
        this.geoRegion = geoRegion;
    }

    public String getIban() {
        return iban;
    }

    public long getAccountHolderId() {
        return accountHolderId.longValue();
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    public String getGeoRegion() {
        return geoRegion;
    }
}
