FROM eleidan/buildpack-deps:ubuntu-14.04

LABEL maintainer="Oleg Kulyk" \
      description="Ruby 2.4.1 based on Ubuntu 14.04" \
      init="docker run -it --rm -v $(pwd):/home/phantom/app eleidan/ruby:2.4.1-ubuntu-14.04 docker-init.sh" \
      run="docker run -it --rm -v $(pwd):/home/phantom/app eleidan/ruby:2.4.1-ubuntu-14.04" \
      version="2017-12-15"

ENV RBENV_VERSION=2.4.1 \
    SERVICE_NAME="ruby:2.4.1-ubuntu-14.04"

### Switch to non-root user
USER phantom

### Install ruby with rbenv
ARG RBENV_PATH="$HOME/.rbenv"
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_PATH \
    && git clone https://github.com/rbenv/ruby-build.git $RBENV_PATH/plugins/ruby-build \
    && cd $RBENV_PATH \
    && src/configure && make -C src \
    && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc \
    && RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/local bin/rbenv install $RBENV_VERSION \
    # Set defaults for gem install
    && echo 'install: --no-document' >> $HOME/.gemrc \
    && echo 'update: --no-document' >> $HOME/.gemrc \
    # Install bundler
    && /bin/bash -l -c 'gem install bundler'

### Switch back to root user
# Needed for entrypoint script running
USER root

COPY docker-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-init.sh

### Needed for the docker-init.sh script
COPY recipes $HOME/recipes

WORKDIR $HOME/app
