package entitlements

test_list_entitlements_by_level_3 {
    entz := entitlements with input as {
       "subject": "agent_smith"
    }
    equals({"account/details", "account/transactions", "account/block"}, entz)
}

equals(expected, result) {
	expected == result
} else = false {
	print("expected equals:", expected, "got:", result)
}