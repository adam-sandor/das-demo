package global.entitlements

entitlements["account/status"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/transactions"] {
  jwt.payload.role == "customer_support"
}

entitlements["account/modify"] {
  jwt.payload.role == "customer_support"
}