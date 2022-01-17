#!/bin/bash

# delete system banking_demo_account
DAS_SYSTEM='banking_demo_account'
DAS_SYSTEM_TYPE='template.istio:1.0'

SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type='$DAS_SYSTEM_TYPE'&name='$DAS_SYSTEM'' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')

curl --request DELETE \
  --url $DAS_TENANT/v1/systems/$SYSTEM_ID \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'



# delete system banking_demo_entitlements
DAS_SYSTEM='banking_demo_entitlements'
DAS_SYSTEM_TYPE='custom'

SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type='$DAS_SYSTEM_TYPE'&name='$DAS_SYSTEM'' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')

curl --request DELETE \
  --url $DAS_TENANT/v1/systems/$SYSTEM_ID \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'



# # delete system banking_demo_gateway
# DAS_SYSTEM='banking_demo_gateway'
# DAS_SYSTEM_TYPE='template.envoy:2.0'

# SYSTEM_ID=$(curl --request GET \
#   --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type='$DAS_SYSTEM_TYPE'&name='$DAS_SYSTEM'' \
#   --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
#   --header 'content-type: application/json' | jq -r '.result[].id')

# curl --request DELETE \
#   --url $DAS_TENANT/v1/systems/$SYSTEM_ID \
#   --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
#   --header 'content-type: application/json'



# delete library jwt
DAS_DATASOURCE='jwt'

curl --request DELETE \
  --url $DAS_TENANT/v1/datasources/global/$DAS_DATASOURCE \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json'



# delete git secret
curl --request DELETE \
  --url $DAS_TENANT/v1/secrets/$DAS_GIT_CREDENTIAL_NAME \
  --header "Authorization: Bearer $DAS_WORKSPACE_TOKEN"
