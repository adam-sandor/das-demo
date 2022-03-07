package policy.ingress

import input.attributes.request as request

default allow = false

principal.accountholder = "spiffe://cluster.local/ns/banking-demo/sa/accountholder-sa"
principal.account = "spiffe://cluster.local/ns/banking-demo/sa/account-sa"

allow {
  input.attributes.destination.principal == principal.accountholder
  input.attributes.source.principal == principal.account
  input.parsed_path = [ "accountholder", _ ]
}

allow {
  input.parsed_path[0] == "portal"
}

allow {
  input.parsed_path[0] = "account"
  input.parsed_path[count(input.parsed_path) - 1] = "details"
  jwt.realm_access.roles[_] = "customer_support"
  jwt.role_level >= 1
}

allow {
  input.parsed_path[0] = "account"
  input.parsed_path[count(input.parsed_path) - 1] = "transactions"
  jwt.realm_access.roles[_] = "customer_support"
  jwt.role_level >= 2
}

allow {
  input.parsed_path[0] = "account"
  input.parsed_path[count(input.parsed_path) - 1] = "block"
  jwt.realm_access.roles[_] = "customer_support"
  jwt.role_level >= 3
}

jwt := payload {
  [_, payload, _] := io.jwt.decode(bearer_token)
}

bearer_token := t {
  v := input.attributes.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
}