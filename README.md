# Commands for testing

## Local

Request entitlements from application:
```shell
curl -H "Authorization: Bearer $(cat config/jwt)" localhost:8080/entitlements/1234
```

Request entitlements from OPA:
```shell
curl -X POST -H "Content-Type:application/json" -d "{\"input\":{\"jwt\":\"$(cat config/jwt)\"}}" localhost:8181/v1/data/entitlements
```

## Remote

Build arm64 image
```shell
docker buildx build --platform linux/amd64 --push -t eu.gcr.io/adam-playground-315708/status-service:latest .
```

## Demo

```shell
curl http://34.88.103.87/status/up

curl http://34.88.103.87/status/details
curl -H "Authorization: Bearer $(cat config/jwt2)" http://34.88.103.87/status/details

curl -H "Authorization: Bearer $(cat config/jwt2)" http://34.88.103.87/banking-api/entitlements/1234
curl -H "Authorization: Bearer $(cat config/jwt)" http://34.88.103.87/banking-api/entitlements/1234
```