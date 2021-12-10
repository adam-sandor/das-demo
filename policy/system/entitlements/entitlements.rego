package entitlements

jwt = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.jwt)
}

default level = 1
level = l {
  l := to_number(jwt.payload.role_level)
}

entitlements["account/details"] {
  jwt.payload.role == "customer_support"
  level >= 1
}

entitlements["account/transactions"] {
  jwt.payload.role == "customer_support"
  level >= 2
}

entitlements["account/modify"] {
  jwt.payload.role == "customer_support"
  level >= 3
}

default allowed = false
allowed {
  entitlements[input.action]
}
