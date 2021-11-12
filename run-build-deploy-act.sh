echo "Running Github Actions locally"

act push -s GKE_SERVICE_ACCOUNT="$(cat config/adam-playground-315708-f59c09e3a969.json)" -s GITHUB_TOKEN="$(cat config/github-token)" --container-architecture linux/amd64