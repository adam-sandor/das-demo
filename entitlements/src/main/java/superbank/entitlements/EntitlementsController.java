package superbank.entitlements;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.bisnode.opa.client.OpaClient;
import com.bisnode.opa.client.query.QueryForDocumentRequest;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
class EntitlementsController {

	private final OpaClient opaClient;

	private static final Logger log = LoggerFactory.getLogger(EntitlementsController.class);

	public EntitlementsController(@Autowired OpaClient opaClient) {
		this.opaClient = opaClient;
	}

	@GetMapping("/entitlements")
	JsonNode entitlements(@RequestHeader(name = "Authorization") String authHeader) {
		log.info("Received entitlements request");
		String token = AuthHeader.getBearerToken(authHeader);

		ObjectNode input = new ObjectMapper().createObjectNode();
		input.put("jwt", token);

		ArrayNode ents = opaClient.queryForDocument(new QueryForDocumentRequest(input, "entitlements/entitlements"), ArrayNode.class);

		ObjectNode output = new ObjectMapper().createObjectNode();
		output.set("entitlements", ents);
		ObjectNode subject = new ObjectMapper().createObjectNode();
		DecodedJWT decodedJWT = JWT.decode(token);
		subject.put("fullname", decodedJWT.getClaim("sub").asString());
		subject.put("role", decodedJWT.getClaim("role").asString());
		subject.put("role_level", decodedJWT.getClaim("role_level").asInt());
		subject.put("geo_region", decodedJWT.getClaim("geo_region").asString());
		output.set("subject", subject);
		return output;
	}


}
