# reset environment

## opt 1: purge everything

```bash
# delete minikube cluster
minikube delete

# delete systems in DAS
./provisioning/das/purge.sh
```

## opt 2: delete resources deployed to minikube

```bash
# set context to namespace `default`
kubectl config set-context minikube --cluster=minikube --namespace=$K8S_NAMESPACE --user=minikube

# delete namespace
kubectl delete namespace $K8S_NAMESPACE

# purge istio
istioctl x uninstall --purge

# delete systems in DAS
./provisioning/das/purge.sh

```
