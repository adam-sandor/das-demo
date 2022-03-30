package policy

import future.keywords.in

entitlements[permission] {
    subject_role_names := entz.roles_bound_to_request_subject
    roles := { role | role := data.object.roles[r]; r in subject_role_names }
    permission := sprintf("%v/%v", [roles[_].allow.include[_].resources[_], roles[_].allow.include[_].actions[_]])
}