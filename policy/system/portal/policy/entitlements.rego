package policy

import future.keywords.in
import data.global.systemtypes["entitlements:1.0"].library.policy.rbac.v1 as entz

entitlements[permission] {
    subject_role_names := entz.roles_bound_to_request_subject
    roles := { role | role := data.object.roles[r]; r in subject_role_names }
    permission := sprintf("%v/%v", [roles[x].allow.include[_].resources[_], roles[x].allow.include[_].actions[_]])
}