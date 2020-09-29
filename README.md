VisualStudio Code server:

* See [cdr/code-server on GitHub](https://github.com/cdr/code-server).
* See [codercom/code-server on DockerHub](https://hub.docker.com/r/codercom/code-server).

## Build custom code-server image

VisualStudio Code server with additional packages installed:

* Java 11 and Maven
* Fortran compiler

Build:

```bash
docker build -t ghcr.io/maastrichtu-ids/vscode-server .
```

Run on http://localhost:8080

```bash
docker run -it --rm --name vscode-server -p 8080:8080 -e PASSWORD=yo ghcr.io/maastrichtu-ids/vscode-server
```

> We recommend to use Google Chrome web browser, copy/paste in the terminal does not work on Firefox.

Push updated image:

```bash
docker push ghcr.io/maastrichtu-ids/vscode-server
```

Use different tags for different versions, e.g. for a Spark build:

```bash
docker build -t ghcr.io/maastrichtu-ids/vscode-server:spark .
```

