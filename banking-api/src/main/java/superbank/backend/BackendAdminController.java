package superbank.backend;

import com.bisnode.opa.client.OpaClient;
import com.bisnode.opa.client.query.QueryForDocumentRequest;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import superbank.backend.opa.EntitlementsInput;

@RestController
class BackendAdminController {

	private final OpaClient opaClient;

	private static final Logger log = LoggerFactory.getLogger(BackendAdminController.class);

	public BackendAdminController(@Autowired OpaClient opaClient) {
		this.opaClient = opaClient;
	}

	@GetMapping("/entitlements/{userid}")
	String[] entitlements(@PathVariable String userid, @RequestHeader(name = "Authorization") String auth) {
		String[] authSplit = auth.split(" ");
		if (!"Bearer".equals(authSplit[0])) {
			throw new IllegalStateException("Unknown Authorization header type: " + authSplit[0]);
		}

		EntitlementsInput input = new EntitlementsInput(authSplit[1], userid);
		log.info("Querying OPA for entitlements");
		String[] entitlements = opaClient.queryForDocument(new QueryForDocumentRequest(input, "entitlements/entitlements"), String[].class);
		log.info("Entitlements for user {} received from OPA: [{}]", userid, StringUtils.join(entitlements, ","));
		return entitlements;
	}


}
