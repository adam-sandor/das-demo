package object

roles := {
	"customer_support_level_1": {"allow": {"include": [{
	    "actions": ["details"],
	    "resources": ["account"]
	}]}},
	"customer_support_level_2": {"allow": {"include": [{
	    "actions": ["details", "transactions"],
	    "resources": ["account"]
	}]}},
	"customer_support_level_3": {"allow": {"include": [{
	    "actions": ["details", "transactions", "block"],
	    "resources": ["account"]
	}]}}
}
