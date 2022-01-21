# setup demo

## prerequisites

First create a .env file from the .env_template in the root of the repo and set all the requested parameters.

```bash
# create copy of `.env_template`, name it `.env` and fill values
# `.env` is listed in .gitignore

source .env
```

## create minikube cluster

```bash
# you might need to restart minikube e.g. after a notebook restart
# docs for available drivers: https://minikube.sigs.k8s.io/docs/drivers/
# set MINIKUBE?DRIVER in your `.env` file

minikube start \
  --driver=$MINIKUBE_DRIVER \
  --cpus 3 \
  --memory=6144 \
  --extra-config=apiserver.enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook
```

## install istio

```bash
istioctl install --set profile=default -y
```

## networking

### minikube tunnel

```bash
# https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-tunnel

# Run tunnel in a separate terminal
# it will ask for a password

minikube tunnel

# Cleaning up orphaned routes
# If the minikube tunnel shuts down in an abrupt manner, it may leave orphaned network routes on your system. 
# If this happens, the ~/.minikube/tunnels.json file will contain an entry for that tunnel. 
# To remove orphaned routes, run:

minikube tunnel --cleanup
```

### local routing

```bash
# get external ip address for istio gateway service
INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo $INGRESS_HOST

# open the file `/etc/hosts` with your prefered editor (elevated permissions necessary) 
# and add following line (use value instead of variable):
<$INGRESS_HOST>       banking.styra-demo.com
```

## create certificates

```bash
# create certificates
./provisioning/k8s/genCerts.sh

# (optional)
# import `styra-demo.com.crt` into chromes trust store
```

## load policies into DAS

```bash
./provisioning/das/load.sh
```

## install microservices

### create namespace

```bash
# create namespace
kubectl create namespace $K8S_NAMESPACE

# edit context
kubectl config set-context minikube --cluster=minikube --namespace=$K8S_NAMESPACE --user=minikube
```

### account

```bash
# get system ID for banking_demo_account
DAS_SYSTEM='banking_demo_account'
DAS_SYSTEM_TYPE='template.istio:1.0'

SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type='$DAS_SYSTEM_TYPE'&name='$DAS_SYSTEM'' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')


# Enable istio-injection for "default" namespace
kubectl label namespaces $K8S_NAMESPACE istio-injection=enabled

# Create envoy filter to route HTTP requests to OPA
curl --request GET \
  --header 'Authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --url ''$DAS_TENANT'/v1/systems/'$SYSTEM_ID'/assets/envoyfilter.yaml' \
  | kubectl apply -f -

# Create OPA config
curl --request GET \
  --header 'Authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --url ''$DAS_TENANT'/v1/systems/'$SYSTEM_ID'/assets/opaconfig.yaml' \
  | kubectl apply -f -

# Deploy Styra Local Plane(SLP)
curl --request GET \
  --header 'Authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --url ''$DAS_TENANT'/v1/systems/'$SYSTEM_ID'/assets/slp.yaml' \
  | kubectl apply -f -


kubectl apply -f $YAML_DIR/account-deploy.yaml

# until added in DAS: overwrite envoyfilter to add workload selector
kubectl apply -f $YAML_DIR/account-envoyfilter.yaml
```

### entitlements

```bash
# get system ID for banking_demo_entitlements
DAS_SYSTEM='banking_demo_entitlements'
DAS_SYSTEM_TYPE='custom'

SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type='$DAS_SYSTEM_TYPE'&name='$DAS_SYSTEM'' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')

# cleanup
rm -rf $YAML_DIR/entitlements-opa-conf-cm.yaml
rm -rf $YAML_DIR/das-opa-conf.yaml

# get OPA config
curl --request GET \
  --header 'Authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --url ''$DAS_TENANT'/v1/systems/'$SYSTEM_ID'/assets/opa-config' \
  -o $YAML_DIR/das-opa-conf.yaml

# assemble opa-conf configmap
cat $YAML_DIR/entitlements-opa-conf-cm-template.yaml >> $YAML_DIR/entitlements-opa-conf-cm.yaml
sed  's/^/    /'  $YAML_DIR/das-opa-conf.yaml >> $YAML_DIR/entitlements-opa-conf-cm.yaml
rm -rf $YAML_DIR/das-opa-conf.yaml

# deploy configmap and deployment
kubectl apply -f $YAML_DIR/entitlements-opa-conf-cm.yaml
kubectl apply -f $YAML_DIR/entitlements-deploy.yaml
```

### portal

```bash
# part of the `banking_demo_account` system

# envoy filter already exists
# OPA config already exists
# SLP deployment already exists

kubectl apply -f $YAML_DIR/portal-deploy.yaml
```

### configure istio

```bash
# create gateway
kubectl apply -f $YAML_DIR/istio-gateway.yaml

# create secret
kubectl create secret tls wildcard.styra-demo.com.certs \
  -n istio-system \
  --key=$YAML_DIR/certs/wildcard.styra-demo.com.key \
  --cert=$YAML_DIR/certs/wildcard.styra-demo.com.crt

# mTLS
# does currently not work wince slp does not have a istio proxy, hence no mTLS
# kubectl apply -f $YAML_DIR/istio-mtls-cluster-strict.yaml
```

## access portal in browser

<https://banking.styra-demo.com/portal>
