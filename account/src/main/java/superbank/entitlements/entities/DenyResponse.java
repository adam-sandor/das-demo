package superbank.entitlements.entities;

import java.util.List;

public class DenyResponse {

    private List<String> denyReasons;

    public DenyResponse(List<String> denyReasons) {
        this.denyReasons = denyReasons;
    }

    public List<String> getDenyReasons() {
        return denyReasons;
    }
}
