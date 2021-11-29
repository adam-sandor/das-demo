curl  -H "Authorization: Bearer $API_TOKEN" -H 'Content-Type: application/json' \
      -X PUT https://adamsandor.svc.styra.com/v1/secrets/github -d "{
    \"name\": \"adam-sandor\",
    \"secret\": \"$(cat ../config/github-token)\"
}"