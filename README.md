# DAS Demo

This repo demonstrates several different scenarios for using OPA and Styra DAS. This includes using
different DAS System types (Custom and Envoy) as well as the usage of Libraries. All System and Library
code is in a single repo, but in a production setup these would probably be separated.

## JWT Library

A simple function parsing the JWT token from the Authorization header is implemented as a Library
under `policy/library`. 

When settings up a Library in Styra DAS it is important to get a few parameters right:
* The directory structure in the Git repo
* The package naming in the rego files
* The Datapath parameter in DAS
* The Repository path parameter in DAS

Hopefull this example will help you set all this up correctly. The [DAS docs](https://docs.styra.com/v1/docs/policy-organization/global-library/mount-git-repos) 
also detail this process but I'm trying to help by giving a very clear example.

Note: I recommend forking this repo and using your own fork as Styra DAS will need authenticated access to the repo.

### Configuring with the UI

You can configure a library from the DAS UI by clicking the + button in the left pane. Here a screenshot how
to configure the different settings. It's important to set Datapath and Repository path correctly.

![](img/library-config-screen.png)

### Configuring with the API

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

### Using the function in your rules

See the `policy/system/gateway/policy/com.styra.envoy.ingress/rules/rules/ingress.rego` rule
for an example on how to actually call the Library function from a System's rules.

The Library's code will be available under the configured Datapath which in our case is
`data.global.jwt`. Note that it always has to be `data.global` only the path after this is configurable.

```rego
jwt = {"valid": valid, "payload": payload} {
  token := data.global.jwt.parse_bearer_token(http_request)
  valid := io.jwt.verify_hs256(token, "this is super secret")

  [_, payload, _] := io.jwt.decode(token)
}
```