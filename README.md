# Consumer Banking Demo

A sample consumer banking application which can be used to demo different features of OPA and Styra DAS.

## Goals / requirements:
* Suffiently complex to demo realistic usage of policies
* Simple enough to be easily understandable and adaptable to different demo scenarios
* Doesn't need a lot of explaining at the beginning of a demo

## Structure

#### `/policy`

Contains all policies used in different Systems and Libraries.

#### `/acount` 

Java / Spring Boot service that  provides bank account data depending on the users entitlements. 
Authorization is implemented using OPA as a sidecar integrated with Istio Envoy.

#### `/entitlements`

Java / Spring Boot service that provides a list of entitlements for the user which the `frontend-portal` uses for displaying UI
elements. Uses an OPA sidecar to get the list of entitlements for a user.

#### `/frontend-portal`

Banking backoffice UI. HTML + jQuery

#### `/status-service`

This service serves a static status page that show if other services like `account` and `entitlements` are up.
The purpose of this service is to show request authorization in the gateway. 

#### `/provisioning/k8s` 

Kubernetes deployment manifests for all components.

#### `/provisioning/das`

Scripts that create Systems, Libraries and other objects in DAS.

#### `.github/workflows`

`deploy.yml`: Builds Docker images and deploys them to Kubernetes when main changes

`policy-pr-check`: Runs decision log replay on PRs and adds comment on PR whether policy changes are causing decision changes