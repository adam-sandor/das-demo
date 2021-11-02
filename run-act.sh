echo "Running Github Actions locally"

act pull_request -s ADAMSANDOR_DAS_API_TOKEN=$(cat config/das-token) -s GITHUB_TOKEN=$(cat config/github-token) --container-architecture linux/amd64