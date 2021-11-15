NS=microservice-demo

kubectl apply -f banking-api/deployment.yaml -n $NS
kubectl apply -f frontend-portal/deployment.yaml -n $NS
kubectl apply -f status-service/deployment.yaml -n $NS

kubectl apply -f k8s/ingress.yaml -n $NS

#we rely on ImagePullPolicy: Always for redeployment of images
kubectl delete pod -l app.kubernetes.io/name=das-microservice-demo