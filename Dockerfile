# Copyright (c) HyperCloud Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Junxiang Wei <kevinprotoss.wei@gmail.com>"

USER root

COPY install-kernels.bash /usr/local/bin/install-kernels
RUN chmod a+rx /usr/local/bin/install-kernels

USER $NB_UID

COPY .condarc $HOME/.condarc
COPY envs /tmp/envs

RUN install-kernels
COPY kernels $HOME/.local/share/jupyter/kernels
