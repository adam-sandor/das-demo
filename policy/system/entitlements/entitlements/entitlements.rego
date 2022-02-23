package entitlements

jwt = {"payload": payload, "roles": roles} {
  [_, payload, _] := io.jwt.decode(input.jwt)
  roles := payload.realm_access.roles
}

entitlements["account/details"] {
  jwt.roles[_] == "customer_support"
  jwt.payload.role_level >= 1
}

entitlements["account/transactions"] {
  jwt.roles[_] == "customer_support"
  jwt.payload.role_level >= 2
}

entitlements["account/block"] {
  jwt.roles[_] == "customer_support"
  jwt.payload.role_level >= 3
}

default allowed = false
allowed {
  entitlements[input.action]
}
