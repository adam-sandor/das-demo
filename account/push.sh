# Build and push using multi-stage Dockerfile
# Output: adamsandor83/account docker image on Dockerhub
# Requires: Docker
docker buildx build --platform linux/amd64 -t adamsandor83/account --push .
