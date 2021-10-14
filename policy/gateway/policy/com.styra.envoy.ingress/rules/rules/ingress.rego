package policy["com.styra.envoy.ingress"].rules.rules

import data.dataset
import input.attributes.request.http as http_request

default allow = false

allow {
  http_request.method == "GET"
  jwt.valid
  startswith(http_request.path, "/banking-api/entitlements")
}

allow {
  http_request.method == "GET"
  startswith(http_request.path, "/status/up")
}

allow {
  http_request.method == "GET"
  jwt.valid
  startswith(http_request.path, "/status/details")
}

allow {
  http_request.method == "GET"
  http_request.path == "/"
}

jwt = {"valid": valid, "payload": payload} {
  token := data.global.jwt.parse_bearer_token(http_request)
  valid := io.jwt.verify_hs256(token, "this is super secret")

  [_, payload, _] := io.jwt.decode(token)
}