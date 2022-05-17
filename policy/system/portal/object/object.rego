package object

actions := [
	"details",
	"transactions",
	"block"
]

groups := data.ldap.groups

resources := {
	"account/details": {"role_level": 1,},
	"account/transactions": {"role_level": 2,},
	"account/block": {"role_level": 3,},
}

role_bindings := data.ldap.role_bindings

roles := {}

users := data.ldap.users