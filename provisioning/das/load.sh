#!/bin/bash

# create git secret
curl --request PUT \
  --url $DAS_TENANT/v1/secrets/$DAS_GIT_CREDENTIAL_NAME \
  --header "Authorization: Bearer $DAS_WORKSPACE_TOKEN" \
  --header 'Content-Type: application/json' \
  --data \
  '{
  "name": "'$GITHUB_USER'",
  "secret": "'$GITHUB_TOKEN'"
  }'



# create system banking_demo_account
curl --request POST \
  --url $DAS_TENANT/v1/systems \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' \
  --data \
  '{
    "name": "banking_demo_account",
    "description": "",
    "read_only": false,
    "type": "template.istio:1.0",
    "source_control": {
      "origin": {
        "credentials": "'$DAS_GIT_CREDENTIAL_NAME'",
        "path": "policy/system/account",
        "reference": "'$GIT_REFERENCE'",
      "url": "'$GIT_URL'"
      }
    }
  }'



# create system banking_demo_entitlements
curl --request POST \
  --url $DAS_TENANT/v1/systems \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' \
  --data \
  '{
    "name": "banking_demo_entitlements",
    "description": "",
    "read_only": false,
    "type": "custom",
    "source_control": {
      "origin": {
        "credentials": "'$DAS_GIT_CREDENTIAL_NAME'",
        "path": "policy/system/entitlements",
        "reference": "'$GIT_REFERENCE'",
      "url": "'$GIT_URL'"
      }
    }
  }'

# cleanup policies banking_demo_entitlements
SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type=custom&name=banking_demo_entitlements' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')
curl --request DELETE \
  --url $DAS_TENANT/v1/policies/systems/$SYSTEM_ID/rules \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'
curl --request DELETE \
  --url $DAS_TENANT/v1/policies/systems/$SYSTEM_ID/test \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'
curl --request DELETE \
  --url $DAS_TENANT/v1/datasources/systems/$SYSTEM_ID/dataset \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'



# create system banking_demo_gateway
# curl --request POST \
#   --url $DAS_TENANT/v1/systems \
#   --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
#   --header 'content-type: application/json' \
#   --data \
#   '{
#     "name": "banking_demo_gateway",
#     "description": "",
#     "read_only": false,
#     "type": "template.envoy:2.0",
#     "source_control": {
#       "origin": {
#         "credentials": "'$DAS_GIT_CREDENTIAL_NAME'",
#         "path": "policy/system/gateway",
#         "reference": "'$GIT_REFERENCE'",
#       "url": "'$GIT_URL'"
#       }
#     }
#   }'



# create library banking_demo_jwt
curl --request PUT \
  --url $DAS_TENANT/v1/datasources/global/jwt \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' \
  --data \
  '{
    "category": "git/rego",
    "credentials": "'$DAS_GIT_CREDENTIAL_NAME'",
    "description": "",
    "enabled": true,
    "on_premises": false,
    "path": "policy/library/global/jwt",
    "polling_interval": 30,
    "rate_limit": 3,
    "reference": "'$GIT_REFERENCE'",
    "timeout": 60,
    "type": "pull",
    "url": "'$GIT_URL'"
  }'
