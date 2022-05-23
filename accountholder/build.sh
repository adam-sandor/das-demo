# Build using multi-stage Dockerfile
# Output: accountholder:latest docker image
# Requires: Docker
docker buildx build --platform linux/amd64 -t accountholder:latest --load .
