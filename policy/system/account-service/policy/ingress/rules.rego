package policy.ingress

import input.attributes.request as request

default allow = false

jwt := payload {
  [_, payload, _] := io.jwt.decode(bearer_token)
}

bearer_token := t {
  v := input.attributes.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
}

allow {
  input.parsed_path = ["account", _, "details"]
  jwt.role = "customer_support"
  jwt.role_level >= 1
}

allow {
  input.parsed_path = ["account", _, "transactions"]
  jwt.role = "customer_support"
  jwt.role_level >= 2
}

allow {
  input.parsed_path = ["account", _, "block"]
  jwt.role = "customer_support"
  jwt.role_level >= 3
}

allow {
  input.parsed_path[0] == "portal"
}
