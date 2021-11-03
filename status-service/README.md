## Build

Build amd64 image (for building on M1 mac)
```shell
docker buildx build --platform linux/amd64 --push -t eu.gcr.io/adam-playground-315708/status-service:latest .
```