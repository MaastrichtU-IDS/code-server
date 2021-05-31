**VisualStudio Code server** images based on https://github.com/cdr/code-server

* Hosted on [GitHub Container Registry](https://github.com/orgs/MaastrichtU-IDS/packages/container/package/code-server) ([ghcr.io](https://ghcr.io)) to avoid DockerHub pull limitations, and easily deploy on clusters (such as Kubernetes).
* Additionally installed on the CPU image: Python3, NodeJS (npm, yarn), Java JDK 11, PHP, Fortran

> Alternative: [jefferyb code-server image for OpenShift](https://github.com/jefferyb/code-server-openshift)

## Automatically updated

[![Publish Docker image](https://github.com/MaastrichtU-IDS/code-server/workflows/Publish%20Docker%20image/badge.svg)](https://github.com/MaastrichtU-IDS/code-server/actions) [![Publish GPU Docker image](https://github.com/MaastrichtU-IDS/code-server/actions/workflows/publish-docker-gpu.yml/badge.svg)](https://github.com/MaastrichtU-IDS/code-server/actions/workflows/publish-docker-gpu.yml)


The image on [ghcr.io](https://ghcr.io) is automatically updated every week (Monday at 3:00 GMT+1) by a GitHub Actions workflow to match the `latest` tag of [codercom/code-server](https://hub.docker.com/r/codercom/code-server)

## Code server on CPU

### Run

```bash
docker run --rm -it -p 8080:8080 -e PASSWORD=password -v $(pwd):/home/coder ghcr.io/maastrichtu-ids/code-server:latest
```

In the container:

* User, with `sudo` privileges: `coder`
* Workspace path: `/home/coder`

### Build

Feel free to edit the `Dockerfile` to install additional packages in the image.

```bash
docker build -t ghcr.io/maastrichtu-ids/code-server:latest .
```

### Push

```bash
docker push ghcr.io/maastrichtu-ids/code-server:latest
```

## Code server on Nvidia GPU

Images hosted on the GitHub Container Registry: https://github.com/orgs/MaastrichtU-IDS/packages/container/package/code-server-gpu

Based on Docker images provided by Nvidia:

* Tensorflow: https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow
* PyTorch: https://ngc.nvidia.com/catalog/containers/nvidia:pytorch

The best way to update the images is to update the version of the environment variables `TENSORFLOW_IMAGE` and `PYTORCH_IMAGE` in the [`publish-docker-gpu.yml` workflow](https://github.com/MaastrichtU-IDS/code-server/blob/main/.github/workflows/publish-docker-gpu.yml), and push the changes to the `main` branch, the new images version will be built and published by GitHub Actions

You can also build the images locally.

Build Tensorflow:

```bash
docker build --build-arg NVIDIA_IMAGE=nvcr.io/nvidia/tensorflow:21.05-tf2-py3 -t ghcr.io/maastrichtu-ids/code-server-gpu:tensorflow-21.05-tf2-py3 -f Dockerfile.gpu .
```

Build PyTorch:

```bash
docker build --build-arg NVIDIA_IMAGE=nvcr.io/nvidia/pytorch:21.05-py3 -t ghcr.io/maastrichtu-ids/code-server-gpu:pytorch-21.05-py3 -f Dockerfile.gpu .
```


Test to run it locally:

```bash
docker run -it --rm -p 8081:8081 -e PASSWORD=password ghcr.io/maastrichtu-ids/code-server-gpu:tensorflow-21.05-tf2-py3
```

Push:

```bash
docker push ghcr.io/maastrichtu-ids/code-server-gpu:tensorflow-21.05-tf2-py3
```

