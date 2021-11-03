package entitlements

jwt = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.jwt)
}

default level = 1
level = l {
  l := jwt.payload.role_level
}

entitlements["account/status"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/transactions"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/modify"] {
  jwt.payload.role == "customer_support"
  level >= 3
}

default allowed = false
allowed {
  entitlements[input.action]
}
