NS=microservice-demo

kubectl create configmap opa-config --from-file=opa-conf.yaml=config/opa-conf-entitlements.yaml -n $NS

kubectl apply -f banking-api/deployment.yaml -n $NS
kubectl apply -f frontend-portal/deployment.yaml -n $NS
kubectl apply -f status-service/deployment.yaml -n $NS

kubectl apply -f k8s/ingress.yaml -n $NS