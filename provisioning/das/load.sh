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

echo "Creating Istio System on $DAS_TENANT"
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
    },
    "decision_mappings": {
      "": {
        "allowed": {
          "path": "result.allowed",
          "negated": false,
          "expected": true
        },
        "reason": {
          "path": "result.outcome.message"
        },
        "columns": [
          {
            "key": "method",
            "path": "input.attributes.request.http.method",
            "type": "string"
          },
          {
            "key": "path",
            "path": "input.attributes.request.http.path",
            "type": "string"
          },
          {
            "key": "host",
            "path": "input.attributes.request.http.host",
            "type": "string"
          },
          {
            "key": "sourceip",
            "path": "input.attributes.source.address.Address.SocketAddress.address",
            "type": "string"
          }
        ]
      },
      "policy/app": {
        "allowed": {
          "path": "result.allowed",
          "negated": false,
          "expected": true
        },
        "reason": null,
        "columns": [
          {
            "key": "iban",
            "path": "input.account.iban",
            "type": ""
          },
          {
            "key": "geo_region",
            "path": "input.account.geo_region",
            "type": ""
          }
        ]
      }
    }
  }'

echo "Creating Portal System on $DAS_TENANT"
curl --request POST \
  --url $DAS_TENANT/v1/systems \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' \
  --data \
  '{
    "name": "banking_demo_portal",
    "description": "Policies for deciding which actions does a user have access to in the UI",
    "read_only": false,
    "type": "template.entitlements:1.0",
    "source_control": {
      "origin": {
        "credentials": "'$DAS_GIT_CREDENTIAL_NAME'",
        "path": "policy/system/portal",
        "reference": "'$GIT_REFERENCE'",
        "url": "'$GIT_URL'"
      }
    }
  }'

PORTAL_SYSTEM_ID=$(curl --request GET \
  --url ''$DAS_TENANT'/v1/systems?compact=true&policies=false&modules=false&datasources=false&errors=false&authz=false&metadata=false&type=template.entitlements:1.0&name=banking_demo_portal' \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' | jq -r '.result[].id')
echo "Portal System ID is $PORTAL_SYSTEM_ID"

curl --request PUT \
  --url $DAS_TENANT/v1/secrets/systems/${PORTAL_SYSTEM_ID}/ldap/credentials \
  --header "Authorization: Bearer $DAS_WORKSPACE_TOKEN" \
  --header 'Content-Type: application/json' \
  --data \
  '{
  "name": "uid=ldapadmin,ou=Users,o=6261cc256155e458568643b2,dc=jumpcloud,dc=com",
  "secret": "12345678"
  }'

DATASOURCE_JSON=$(cat << EOF
{
  "ca_certificate": "",
  "category": "ldap",
  "credentials": "systems/${PORTAL_SYSTEM_ID}/ldap/credentials",
  "description": "",
  "enabled": true,
  "id": "systems/${PORTAL_SYSTEM_ID}/ldap",
  "policy_filter": "systems/${PORTAL_SYSTEM_ID}/transform/jumpcloud/jumpcloud.rego",
  "policy_query": "data.transform.jumpcloud.all",
  "polling_interval": 3600,
  "rate_limit": 3,
  "search": {
    "attributes": [],
    "base_DN": "o=6261cc256155e458568643b2,dc=jumpcloud,dc=com",
    "deref": "never",
    "filter": "(objectClass=inetOrgPerson)",
    "page_size": 0,
    "scope": "whole-subtree",
    "size_limit": 0
  },
  "type": "pull",
  "urls": [
    "ldaps://ldap.jumpcloud.com"
  ]
}
EOF
)

curl --request PUT \
  --url "$DAS_TENANT/v1/datasources/systems/${PORTAL_SYSTEM_ID}/ldap" \
  --header 'authorization: Bearer '$DAS_WORKSPACE_TOKEN'' \
  --header 'content-type: application/json' \
  --data "$DATASOURCE_JSON"

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
