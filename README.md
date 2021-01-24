[![Publish Docker image](https://github.com/MaastrichtU-IDS/vscode-server/workflows/Publish%20Docker%20image/badge.svg)](https://github.com/MaastrichtU-IDS/vscode-server/actions)

VisualStudio Code server image based on https://github.com/cdr/code-server

* Hosted on GitHub Container Registry to avoid DockerHub pull limitations.

* Additionally installed: Python3, yarn, PHP and Fortran

Alternative: [jefferyb image for OpenShift](https://github.com/jefferyb/code-server-openshift)

## Automatically updated

The image is automatically updated every week by a GitHub Actions workflow to the `latest` tag of [codercom/code-server](https://hub.docker.com/r/codercom/code-server)

## Build

```bash
docker build -t ghcr.io/maastrichtu-ids/vscode-server:latest .
```

## Push

```bash
docker push ghcr.io/maastrichtu-ids/vscode-server:latest
```

## Run

```bash
docker run --rm -it -p 8080:8080 -e PASSWORD=password -v $(pwd):/home/coder ghcr.io/maastrichtu-ids/vscode-server:latest
```

In the container:

* User with `sudo` privilege: `coder`
* Workspace path: `/home/coder`