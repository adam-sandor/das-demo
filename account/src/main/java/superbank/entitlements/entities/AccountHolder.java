package superbank.entitlements.entities;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.springframework.boot.json.JsonParser;
import org.springframework.boot.json.JsonParserFactory;

import java.util.Map;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

public class AccountHolder {

    private static JsonParser jsonParser = JsonParserFactory.getJsonParser();

    private String name;
    private String address;

    protected AccountHolder() {}

    public AccountHolder(String name, String address) {
        this.name = name;
        this.address = address;
    }

    public AccountHolder(String json) {
        Map<String, Object> parsedJson = jsonParser.parseMap(json);
        this.name = parsedJson.getOrDefault("name", "<null>").toString();
        this.address = parsedJson.getOrDefault("address", "<null>").toString();
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
