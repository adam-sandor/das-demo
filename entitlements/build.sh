# Build using multi-stage Dockerfile
# Output: entitlements:latest docker image
# Requires: Docker
docker buildx build --platform linux/amd64 -t entitlements:latest .