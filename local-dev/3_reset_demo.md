# reset environment

## opt 1: purge everything

```bash
# delete minikube cluster
minikube delete --profile $MINIKUBE_PROFILE

# delete systems in DAS
./provisioning/das/purge.sh

# unset env variables
source .unset_env
```

## opt 2: delete resources deployed to minikube

```bash
# set context to namespace `default`
kubectl config set current-context $MINIKUBE_PROFILE
kubectl config set-context $MINIKUBE_PROFILE --cluster=$MINIKUBE_PROFILE --namespace=default --user=$MINIKUBE_PROFILE

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
