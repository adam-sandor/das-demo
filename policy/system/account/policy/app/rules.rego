package policy.app

deny[message] {
    input.subject.role != "customer_support"
    message := sprintf("unauthorized role %v", [input.subject.role])
}

deny[message] {
    input.subject.role_level < 1
    message := sprintf("role level too low %v", [input.subject.role_level])
}

deny[message] {
    input.subject.geo_region != input.account.geo_region
    message := sprintf("geo region of customer support employee (%v) doesn't match account's (%v)", [input.subject.geo_region, input.account.geo_region])
}
