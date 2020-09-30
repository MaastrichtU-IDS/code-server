Built based on https://github.com/jackfrost373/jupyter-root/tree/master/root-notebook

## Build custom code-server image

JupyterLab with additional packages and kernel installed:

* Jupyter `scipy` and `tensorflow` packages installed
* Java 11 and Maven
* IJava kernel
* SPARQL kernel

Build:

```bash
docker build -t ghcr.io/maastrichtu-ids/jupyterlab-on-openshift .
```

Run on http://localhost:8888

```bash
docker run -it --rm --name jupyterlab-on-openshift -p 8888:8888 -e JUPYTER_NOTEBOOK_PASSWORD=password ghcr.io/maastrichtu-ids/jupyterlab-on-openshift
```

Push updated image:

```bash
docker push ghcr.io/maastrichtu-ids/jupyterlab-on-openshift
```

Use different tags for different versions, e.g. for a Scala build:

```bash
docker build -t ghcr.io/maastrichtu-ids/jupyterlab-on-openshift:scala .
```
