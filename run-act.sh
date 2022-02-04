echo "Running Github Actions locally"

act pull_request -s STYRA_API_TOKEN=${API_TOKEN} -s GITHUB_TOKEN=${GITHUB_TOKEN} --container-architecture linux/amd64