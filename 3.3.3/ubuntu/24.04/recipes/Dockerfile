FROM eleidan/ruby:3.3.3-ubuntu-24.04

RUN mkdir ${HOME}/.bundle

USER root

### Adopt container user for the host UID and GID
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN usermod -u ${HOST_UID} phantom
RUN groupmod -g ${HOST_GID} phantom
RUN chown -R phantom:phantom ${HOME}

USER phantom
WORKDIR ${HOME}/app
