# Copyright (c) HyperCloud Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Junxiang Wei <kevinprotoss.wei@gmail.com>"

USER root

COPY install-kernels.bash /usr/local/bin/install-kernels
RUN chmod a+rx /usr/local/bin/install-kernels

# Prepare directories for required libraries and common codes
RUN mkdir -p /share/lib/jupiter && \
    ln -s /share/lib/jupiter $HOME/work/jupiter && \
    mkdir -p /share/commons && \
    ln -s /share/commons $HOME/work/commons

USER $NB_UID

# Overwrite local channel configurations for domestic use
COPY .condarc $HOME/.condarc
# Add all kernel environments
COPY envs /tmp/envs
RUN install-kernels
# Overwrite with custom kernel definitions
COPY kernels $HOME/.local/share/jupyter/kernels
