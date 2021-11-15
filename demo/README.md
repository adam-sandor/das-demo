# Commands for testing

## Local

Request entitlements from application:
```shell
curl -H "Authorization: Bearer $(cat jane-doe-us.jwt)" localhost:8080/entitlements
```

Request entitlements from OPA:
```shell
curl -X POST -H "Content-Type:application/json" -d "{\"input\":{\"jwt\":\"$(cat jwt)\"}}" localhost:8181/v1/data/entitlements

curl -X POST -H "Content-Type:application/json" -d "{\"input\":{\"jwt\":\"$(cat jwt)\", \"action\": \"account/transactions\"}}" localhost:8181/v1/data/entitlements/allowed
```

## Build

Build amd64 image (for building on M1 mac)
```shell
docker buildx build --platform linux/amd64 --push -t eu.gcr.io/adam-playground-315708/status-service:latest .
```

## Demo

```shell
curl http://${INGRESS_IP}/status/up

curl http://${INGRESS_IP}/status/details
curl -H "Authorization: Bearer $(cat jane-doe-us.jwt)" http://${INGRESS_IP}/status/details

curl -H "Authorization: Bearer $(cat john-doe-us.jwt)" http://${INGRESS_IP}/entitlements
curl -H "Authorization: Bearer $(cat jane-doe-us.jwt)" http://${INGRESS_IP}/entitlements
```