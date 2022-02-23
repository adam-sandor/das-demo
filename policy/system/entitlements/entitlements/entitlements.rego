package entitlements

jwt = {"payload": payload} {
  [_, payload, _] := io.jwt.decode(input.jwt)
}

entitlements["account/details"] {
  jwt.payload.role[_] == "customer_support"
  jwt.payload.role_level >= 1
}

entitlements["account/transactions"] {
  jwt.payload.role[_] == "customer_support"
  jwt.payload.role_level >= 2
}

entitlements["account/block"] {
  jwt.payload.role[_] == "customer_support"
  jwt.payload.role_level >= 3
}

default allowed = false
allowed {
  entitlements[input.action]
}
