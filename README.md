# JupyterFund Workspace

[![Docker Pulls](https://img.shields.io/docker/pulls/jupiterfund/workspace.svg)](https://hub.docker.com/r/jupiterfund/workspace/)

### How to build

```bash
docker build -t jupiterfund/workspace .
```

### Run the latest stable version

```bash
# Enable jupyter lab mode
docker run -d -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes kevinprotoss/workspace:latest

```

Go to http://localhost:8888 to access it.
