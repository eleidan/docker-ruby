FROM eleidan/base:ubuntu-16.04

LABEL maintainer="Oleg Kulyk" \
      description="Ruby 2.2.2 based on Ubuntu 16.04" \
      init="docker run -it --rm --user $(id -u):$(id -g) -v $(pwd):/home/phantom/app eleidan/ruby:2.2.2-ubuntu-16.04 docker-init.sh" \
      run="docker run -it --rm --user $(id -u):$(id -g) -v $(pwd):/home/phantom/app eleidan/ruby:2.2.2-ubuntu-16.04" \
      version="2019-01-18"

ENV RBENV_VERSION=2.2.2 \
    SERVICE_NAME="ruby:2.2.2-ubuntu-16.04"

### Switch to non-root user
USER phantom

#################################################################################
## Ruby
#ENV RUBY_MAJOR=2.2 \
#    RUBY_VERSION=2.2.10
#ENV GEM_HOME=/home/phantom/bundle
#ENV BUNDLE_APP_CONFIG=${GEM_HOME}
#
##from https://github.com/docker-library/ruby/blob/d4d6ba59b2b0ff95c178a46bfc362675eb507177/2.1/Dockerfile
#RUN mkdir -p /usr/src/ruby \
#    && curl -SL "http://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_VERSION}.tar.bz2" \
#    | tar -xjC /usr/src/ruby --strip-components=1 \
#    && cd /usr/src/ruby \
#    && autoconf \
#    && ./configure --disable-install-doc \
#    && make -j"$(nproc)" \
#    && make install \
#    && cd / \
#    && rm -r /usr/src/ruby \
#    && echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

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

### Needed for the docker-init.sh script
COPY --chown=phantom:phantom recipes $HOME/recipes

RUN chown phantom:phantom -R ${HOME}

WORKDIR $HOME/app
