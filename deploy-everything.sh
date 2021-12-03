NS=microservice-demo

kubectl apply -f provisioning/k8s -n $NS

#we rely on ImagePullPolicy: Always for redeployment of images
kubectl delete pod -l app.kubernetes.io/name=das-microservice-demo -n $NS