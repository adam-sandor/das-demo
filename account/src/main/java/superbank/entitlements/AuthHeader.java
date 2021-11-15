package superbank.entitlements;

public class AuthHeader {

    public static String getBearerToken(String authHeader) {
        String[] authSplit = authHeader.split(" ");
        if (!"Bearer".equals(authSplit[0]) || authSplit.length != 2) {
            throw new IllegalStateException("Unknown Authorization header format: " + authHeader);
        }
        return authSplit[1];
    }
}
