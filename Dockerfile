# Copyright (c) HyperCloud Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Junxiang Wei <kevinprotoss.wei@gmail.com>"

USER root

COPY install-kernels.bash /usr/local/bin/install-kernels
RUN chmod a+rx /usr/local/bin/install-kernels

COPY envs /tmp/envs
COPY extensions /tmp/extensions
COPY kernels $HOME/.local/share/jupyter/kernels
COPY user-settings $HOME/.jupyter/lab/user-settings
# Custom channel configurations for domestic use
COPY .condarc $HOME/.condarc

# Prepare directories
# `--chown` does not work for dockerhub because of docker version 18.03
RUN mkdir -p /share/jupiterapis && \
    ln -s /share/jupiterapis $HOME/jupiterapis && \
    mkdir -p /share/commons && \
    ln -s /share/commons $HOME/commons && \
    chown -R $NB_UID:$NB_GID /tmp && \
    chown -R $NB_UID:$NB_GID $HOME

USER $NB_UID

RUN install-kernels && \
    conda install -y -c conda-forge jupyterlab-git=0.9.0 && \
    jupyter labextension install $(tr '\n' ' ' < /tmp/extensions/labextensions.txt) && \
    jupyter lab build && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter serverextension list && \
    jupyter labextension list

# Extend PYTHONPATH for external libraries
ENV PYTHONPATH="${PYTHONPATH}:/share/jupiterapis:/share/commons"
