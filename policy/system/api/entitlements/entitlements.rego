package entitlements

jwt = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.jwt)
}

default level = 0
level = {
  input.token.level
}

entitlements["account/status"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/transactions"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/modify"] {
  jwt.payload.role == "customer_support"
  level > 3
}

allow {
  entitlements[input.action]
}