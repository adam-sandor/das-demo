package system.authz

# NOTE: This policy does not apply by default in the Kong Mesh
# and Kuma system types as they do not enable OPA Authorization.
# See https://www.openpolicyagent.org/docs/latest/security/ for
# More information.

# Deny access by default.
default allow = true