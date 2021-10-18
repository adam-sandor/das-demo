# DAS Demo

This repo demonstrates several different scenarios for using OPA and Styra DAS. This includes using
different DAS System types (Custom and Envoy) as well as the usage of Libraries. All System and Library
code is in a single repo, but in a production setup these would probably be separated.

## JWT Library

A simple function parsing the JWT token from the Authorization header is implemented as a Library
under `policy/library`. It is important to get the package structure and the package declarations in the
rego files right for Styra DAS to load the Library successfully. The next step is to configure the
Library in Styra DAS.

You will have to have SSH access to the repo, so I recommend forking it so you can use your own keys for access.

```shell
export TENANT="adamsandor.svc.styra.com"  # the tenant URL of SaaS Styra DAS or an on-prem URL 
export API_TOKEN="abcdefg"                # this is generated in the workspace admin settings
# replace newlines in the key with \n
```

Create a secret with the private key used to access Git. This is for access using SSH keys, alternatively
you can use an HTTP username and password. In that case `name` should be a the username and the password
goes in `secret`. In the SSH case `name` is not significant.

Replace all newlines in your private key with `\n`.

```shell
curl -X PUT "https://${TENANT}/v1/secrets/git-pk" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $API_TOKEN" \
--data-raw '{
  "description": "SSH Private Key",
  "name": "git-pk",
  "secret": "-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZAAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW\nQyNTUxOQAAACC9o51p/b2oV6aFOhHcOxBQImsuNzmzj3uAnPPn0PYKXQAAAJgkHc1SJB3N\nUgAAAAtzc2g7A0igFqqXukmbf7EVk0Lkb2jnWn9vahXpoU6Edw7EFAi\nay43ObOPe4Cc8+fQ9gpdAAXXXXkYW1Ac3R5cmEuY29tAQIDBAUGBw==\n-----END OPENSSH PRIVATE KEY-----"
}'
```

Create the Library by referencing the secret created in the previous step. Replace repo URL with your fork.

```shell
curl -X PUT "https://${TENANT}/v1/datasources/global/jwt" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $API_TOKEN" \
--data-raw '{
    "category": "git/rego",                           
    "type": "pull",
    "url": git@github.com:adam-sandor/das-demo.git,   
    "path": "policy/library/global/jwt",
    "reference": "refs/heads/main",
    "ssh_credentials": 
    {
        "private_key": "git-pk"
    }                               
}
```