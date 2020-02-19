# Copyright (c) HyperCloud Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Junxiang Wei <kevinprotoss.wei@gmail.com>"

USER root

COPY install-kernels.bash /usr/local/bin/install-kernels
RUN chmod a+rx /usr/local/bin/install-kernels

# Prepare directories for required libraries and common codes
RUN mkdir -p /share/jupiterapis && \
    ln -s /share/jupiterapis $HOME/jupiterapis && \
    mkdir -p /share/commons && \
    ln -s /share/commons $HOME/commons

USER $NB_UID

# Custom channel configurations for domestic use
COPY .condarc $HOME/.condarc

# Kernel environments
COPY --chown=$NB_UID:$NB_GID envs /tmp/envs
#RUN install-kernels
# Kernel definitions
COPY --chown=$NB_UID:$NB_GID kernels $HOME/.local/share/jupyter/kernels

# Jupyter lab settings
RUN mkdir -p $HOME/.jupyter/lab
COPY --chown=$NB_UID:$NB_GID user-settings $HOME/.jupyter/lab/user-settings
# Jupyter lab extensions
COPY --chown=$NB_UID:$NB_GID extensions /tmp/extensions
RUN conda install -y -c conda-forge jupyterlab-git=0.9.0
RUN jupyter labextension install $(tr '\n' ' ' < /tmp/extensions/labextensions.txt)
RUN jupyter lab build
RUN jupyter serverextension enable --py jupyterlab_git
RUN jupyter serverextension list
RUN jupyter labextension list

# Extend PYTHONPATH for external libraries
ENV PYTHONPATH="${PYTHONPATH}:/share/jupiterapis:/share/commons"

