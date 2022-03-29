package object

role_bindings := {
	"account/block": {"subjects": {
        "membership-attributes": {"geo_region": "EU", "role_level": 3},
        "ids": ["customer_support"],
    }},
	"account/transactions": {"subjects": {
        "membership-attributes": {"geo_region": "EU", "role_level": 2},
        "ids": ["customer_support"],
    }},
    "account/details": {"subjects": {
        "membership-attributes": {"geo_region": "EU", "role_level": 1},
        "ids": ["customer_support"],
    }}
}
