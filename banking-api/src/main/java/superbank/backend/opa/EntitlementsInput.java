package superbank.backend.opa;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class EntitlementsInput {

    private String jwt;
    private String userid;

    @JsonCreator
    public EntitlementsInput(@JsonProperty("jwt") String jwt, @JsonProperty("userid") String userid) {
        this.jwt = jwt;
        this.userid = userid;
    }

    public String getJwt() {
        return jwt;
    }

    public String getUserid() {
        return userid;
    }
}
