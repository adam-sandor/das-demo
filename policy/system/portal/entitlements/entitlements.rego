package entitlements

entitlements[resource] {
  data.object.users[jwt.username].role == "customer_support"
  data.object.users[jwt.username].role_level >= data.object.resources[resource].role_level
}

default allowed = false
allowed {
  input.action
  entitlements[input.action]
}

allowed {
  not input.action
  count(entitlements) > 0
}

jwt = {"username": username} {
  [_, payload, _] := io.jwt.decode(input.jwt)
  username := payload.preferred_username
}