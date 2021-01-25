**VisualStudio Code server** image based on https://github.com/cdr/code-server

* Hosted on [GitHub Container Registry](https://github.com/orgs/MaastrichtU-IDS/packages/container/package/code-server) ([ghcr.io](https://ghcr.io)) to avoid DockerHub pull limitations, and easily deploy on clusters (such as Kubernetes).
* Additionally installed: Python3, NodeJS (npm, yarn), Java JDK 11, PHP, Fortran

> Alternative: [jefferyb code-server image for OpenShift](https://github.com/jefferyb/code-server-openshift)

## Automatically updated

[![Publish Docker image](https://github.com/MaastrichtU-IDS/code-server/workflows/Publish%20Docker%20image/badge.svg)](https://github.com/MaastrichtU-IDS/code-server/actions)


The image on [ghcr.io](https://ghcr.io) is automatically updated every week (Monday at 3:00 GMT+1) by a GitHub Actions workflow to match the `latest` tag of [codercom/code-server](https://hub.docker.com/r/codercom/code-server)

## Run

```bash
docker run --rm -it -p 8080:8080 -e PASSWORD=password -v $(pwd):/home/coder ghcr.io/maastrichtu-ids/code-server:latest
```

In the container:

* User, with `sudo` privileges: `coder`
* Workspace path: `/home/coder`

## Build

Feel free to edit the `Dockerfile` to install additional packages in the image.

```bash
docker build -t ghcr.io/maastrichtu-ids/code-server:latest .
```

## Push

```bash
docker push ghcr.io/maastrichtu-ids/code-server:latest
```
