package policy

enforce[decision] {
  data.global.systemtypes["entitlements:1.0"].library.policy.rbac.v1.any_role_allows_access[message]
  decision := {
    "allowed": true,
    "entz": set(),
    "message": message
  }
}

monitor[decision] {
  data.global.systemtypes["entitlements:1.0"].library.policy.rbac.v1.roles_bound_to_request_subject[message]
  decision := {
    "allowed": true,
    "entz": set(),
    "message": message
  }
}
# By default, requests are denied and have no entitlements
#
# Rules that allow a request should be of the form:
# enforce[decision] {
#     input.subject == "user@acme.org"
#     decision := {
#         "allowed": true,
#         "message": "optional message: why request was allowed",
#         "entz": {"optional set", "contains any type of object"}
#     }
# }
#
# Rules that deny a request should be of the form:
# enforce[decision] {
#     input.context.location == "Mars"
#     decision := {
#         "denied": true,
#         "message": "optional message: why request was denied",
#         "entz": {"optional set"}
#     }
# }
#
# If a request is denied by any rule, then the request is denied

