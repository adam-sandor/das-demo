package superbank.entitlements;

import com.bisnode.opa.client.OpaClient;
import com.bisnode.opa.client.query.QueryForDocumentRequest;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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

		ObjectNode results = opaClient.queryForDocument(new QueryForDocumentRequest(input, "entitlements"), ObjectNode.class);
		return results.get("entitlements");
	}


}
