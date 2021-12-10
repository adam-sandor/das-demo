package policy.app

transactions := [ t | t := input.transactions[_]; allowed_for_user(input.subject, t) ]

allowed_for_user(user, tx) {
	print(user.role)
	user.role = "customer_support"
    user.role_level >= 3
}

allowed_for_user(user, tx) {
	print(user.role)
	user.role = "customer_support"
    user.role_level >= 1
    tx.result != "SUCCESS"
}