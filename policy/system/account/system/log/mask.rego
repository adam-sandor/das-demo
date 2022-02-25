package system.log

# The policy below instructs OPA to remove all data from secrets before uploading the decision
# https://www.openpolicyagent.org/docs/latest/decision-logs/#masking-sensitive-data
# Note: this is an example; update the policy to reflect your configuration

# mask["/input/request/http/headers/token"]

# mask["/input/attributes/request/http/headers/authorization"]
