# Banking Customer Service Portal Demo

This demo application simulates a customer support portal for a consumer bank (called SuperBank). It demonstrates the 
usage of OPA and Styra DAS to secure the application's microservices.

## Goals / requirements

* Suffiently complex to demo realistic usage of policies
* Simple enough to be easily understandable and adaptable to different demo scenarios
* Doesn't need a lot of explaining at the beginning of a demo
* Shows RBAC and ABAC policies

## Building service Docker images

Each microservice runs as a Docker image. To build these images you can use the `build.sh` script in each service's
directory.

```
cd account
./build.sh

cd entitlements
./build.sh

cd frontend-portal
./build.sh
```

#### Using Jib to build Java service images faster

[Jib](https://github.com/GoogleContainerTools/jib) is a Java tool that hooks into the Maven build of the project to
produce a Docker image. Using this method is faster than the pure Docker-based build as it will use the local
Maven cache to store dependencies. You need a JDK and Maven to be installed to use this method. Mainly recommended for
those who want to actively work on the code of these services.

```
cd account
./build-jib.sh

cd entitlements
./build-jib.sh
```

4. Deploy application - step 1 - load images to registry

## Architecture

See Repo structure section for explanation of different components here.

![architecture-diagram.jpg](/img/architecture.jpg)

## Repo structure

### `/policy`

Contains all policies used in different Systems and Libraries.

### `/account`

Java / Spring Boot service that  provides bank account data depending on the users entitlements.  
Authorization is implemented using OPA as a sidecar integrated with Istio Envoy.

### `/entitlements`

Java / Spring Boot service that provides a list of entitlements for the user which the `frontend-portal` uses for displaying UI elements. Uses an OPA sidecar to get the list of entitlements for a user.

### `/frontend-portal`

Banking backoffice UI. HTML + jQuery

### `/status-service`

This service serves a static status page that shows if other services like `account` and `entitlements` are up.
The purpose of this service is to show request authorization in the gateway.

### `/provisioning/k8s`

Kubernetes deployment manifests for all components.

### `/provisioning/das`

Scripts that create Systems, Libraries and other objects in DAS.

### `.github/workflows`

`deploy.yml`: Builds Docker images and deploys them to Kubernetes when main changes  
`policy-pr-check`: Runs decision log replay on PRs and adds comments on PR whether policy changes are causing decision changes
