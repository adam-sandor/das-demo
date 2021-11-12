## Styra CLI in GH actions

The `styra/cli` image doesn't have bash in it and that trips up GH actions:

```yaml
obs:
  build:
    runs-on: ubuntu-latest
    container: styra/cli
    steps:
      - uses: actions/checkout@v2
      - name: Configure Styra CLI
        env:
          API_KEY: ${{ secrets.ADAMSANDOR_DAS_API_TOKENN }}
        run:
          /usr/local/bin/styra-cli configure -i https://adamsandor.svc.styra.com -t ${API_KEY}
      - name: Test
        uses: docker://styra/cli
        with:
          entrypoint: /usr/local/bin/styra-cli
          args: styra validate logreplay -p global/jwt=library/global/jwt/jwt.rego --system=dc105efba51d4f59b419d3979d8ae0e6
```

```
[Verify Pull Request/build] 🚀  Start image=styra/cli
[Verify Pull Request/build]   🐳  docker run image=styra/cli platform=linux/amd64 entrypoint=["/usr/bin/tail" "-f" "/dev/null"] cmd=[]
[Verify Pull Request/build]   🐳  docker exec cmd=[mkdir -m 0777 -p /var/run/act] user=root
[Verify Pull Request/build]   🐳  docker cp src=/Users/adam/Projects/das-webinar/. dst=/Users/adam/Projects/das-webinar
[Verify Pull Request/build]   🐳  docker exec cmd=[mkdir -p /Users/adam/Projects/das-webinar] user=
[Verify Pull Request/build] ⭐  Run actions/checkout@v2
[Verify Pull Request/build]   ✅  Success - actions/checkout@v2
[Verify Pull Request/build] ⭐  Run Configure Styra CLI
[Verify Pull Request/build]   🐳  docker exec cmd=[bash --noprofile --norc -e -o pipefail /Users/adam/Projects/das-webinar/workflow/1] user=
| OCI runtime exec failed: exec failed: container_linux.go:380: starting container process caused: exec: "bash": executable file not found in $PATH: unknown
[Verify Pull Request/build]   ❌  Failure - Configure Styra CLI
```

Adding `sh` as default shell is causing a weird runtime issue
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: styra/cli
    defaults:
      run:
        shell: sh
```

```
[Verify Pull Request/build]   🐳  docker exec cmd=[mkdir -p /Users/adam/Projects/das-webinar] user=
[Verify Pull Request/build] ⭐  Run actions/checkout@v2
[Verify Pull Request/build]   ✅  Success - actions/checkout@v2
[Verify Pull Request/build] ⭐  Run Configure Styra CLI
[Verify Pull Request/build]   🐳  docker exec cmd=[sh -e -c /Users/adam/Projects/das-webinar/workflow/1] user=
| 1: applet not found
```

When running on GH directly instead of Act I'm getting this error too:

```
Run actions/checkout@v2
/usr/bin/docker exec  31e9255d265de3879d8702124a6a39057ba3f0f4b62f059ddb1d59593090b06c sh -c "cat /etc/*release | grep ^ID"
Syncing repository: adam-sandor/das-demo
Getting Git version info
Deleting the contents of '/__w/das-demo/das-demo'
The repository will be downloaded using the GitHub REST API
To create a local Git repository instead, add Git 2.18 or higher to the PATH
Downloading the archive
Writing archive to disk
Error: EACCES: permission denied, open '/__w/das-demo/das-demo/aa384cb6-c3d3-4084-9d6b-f8d023b75ebd.tar.gz'
```