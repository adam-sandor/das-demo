package policy

test_list_entitlements_by_level_3 {
    print("1234")
    entz := entitlements with input as {
       "subject": "agent_smithh"
    }
    equals({"a", "b"}, entz)
}

equals(expected, result) {
	expected == result
} else = false {
	print("expected equals:", _quote_str(expected), "got:", result)
}