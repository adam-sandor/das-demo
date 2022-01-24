# Build using multi-stage Dockerfile
# Output: account:latest docker image
# Requires: Docker
docker buildx build --platform linux/amd64 -t account:latest .
