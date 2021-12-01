curl  -H "Authorization: Bearer $API_TOKEN" -H 'Content-Type: application/json' \
      -X POST https://adamsandor.svc.styra.com/v1/systems -d '{
  "description": "Istio System for Account Service",
  "name": "Account Service",
  "read_only": false,
  "type": "template.istio:1.0",
  "source_control": {
    "origin": {
      "credentials": "github",
      "path": "policy/system/account-service",
      "reference": "refs/heads/main",
      "url": "https://github.com/adam-sandor/das-demo.git"
    }
  }
}' | jq -r .result.id > state/acount_system_id