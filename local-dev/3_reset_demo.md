# reset environment

## opt 1: purge everything

```bash
# delete minikube cluster
minikube delete

# delete systems in DAS
./provisioning/das/purge.sh

# unset env variables
source .unset_env
```

## opt 2: delete resources deployed to minikube

```bash
# set context to namespace `default`
kubectl config set-context minikube --cluster=minikube --namespace=default --user=minikube

# delete namespace
kubectl delete namespace $K8S_NAMESPACE

# purge istio
istioctl x uninstall --purge -y
kubectl delete ns istio-system

# delete systems in DAS
./provisioning/das/purge.sh

# unset env variables
source .unset_env
```
