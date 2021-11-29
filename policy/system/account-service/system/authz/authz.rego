package system.authz

# NOTE: This policy does not apply by default in the Kong Mesh
# and Kuma system types as they do not enable OPA Authorization.
# See https://www.openpolicyagent.org/docs/latest/security/ for
# More information.

# Deny access by default.
default allow = true

# Allow access to application data.
allow {
	input.path = ["v1", "data", "application", "main"]
	input.method = "POST"
}

# This is only used for health check in liveness and readiness probe
allow {
	input.path = ["health"]
	input.method = "GET"
}

# This is only used for prometheus metrics
allow {
	input.path = ["metrics"]
	input.method = "GET"
}
