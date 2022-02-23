package policy.app
import future.keywords.in

transactions := [ t | t := input.transactions[_]; allowed_for_user(input.subject, t) ]

allowed_for_user(user, tx) {
	"customer_support" in input.subject.roles
    user.role_level >= 3
}

allowed_for_user(user, tx) {
	"customer_support" in input.subject.roles
    user.role_level >= 1
    tx.result != "SUCCESS"
}