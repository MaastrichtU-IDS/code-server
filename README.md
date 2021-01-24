VisualStudio Code server image based on https://github.com/cdr/code-server

Additionally installed: Python3, yarn, PHP and Fortran

> Hosted on GitHub Container Registry to avoid DockerHub pull limitations.

See also: [jefferyb image for OpenShift](https://github.com/jefferyb/code-server-openshift)

## Automatically updated

The image is automatically updated every week by a GitHub Actions workflow to [codercom/code-server:latest](https://hub.docker.com/r/codercom/code-server)

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