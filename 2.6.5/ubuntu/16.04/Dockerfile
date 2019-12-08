FROM eleidan/base:ubuntu-16.04

LABEL maintainer="Oleg Kulyk" \
      description="Ruby 2.6.5 based on Ubuntu 16.04" \
      init="docker run -it --rm --user $(id -u):$(id -g) -v $(pwd):/home/phantom/app eleidan/ruby:2.6.5-ubuntu-16.04 docker-init.sh" \
      run="docker run -it --rm --user $(id -u):$(id -g) -v $(pwd):/home/phantom/app eleidan/ruby:2.6.5-ubuntu-16.04" \
      version="2019-12-08"

ENV SERVICE_NAME="ruby:2.6.5-ubuntu-16.04"

#################################################################################
## Ruby
ENV RUBY_MAJOR="2.6"
ENV RUBY_VERSION="2.6.5"
ENV GEM_HOME="/home/phantom/.bundle"
ENV BUNDLE_APP_CONFIG="${GEM_HOME}"
ENV PATH="$PATH:${GEM_HOME}/bin"

USER root
# skip installing gem documentation
RUN set -eux; \
	mkdir -p /usr/local/etc; \
	{ \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

#from https://github.com/docker-library/ruby/blob/d4d6ba59b2b0ff95c178a46bfc362675eb507177/2.1/Dockerfile
RUN mkdir -p /usr/src/ruby \
    && curl -SL "http://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_VERSION}.tar.bz2" \
    | tar -xjC /usr/src/ruby --strip-components=1 \
    && cd /usr/src/ruby \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)" \
    && make install \
    && cd / \
    && rm -r /usr/src/ruby \
    && echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

### Needed for the docker-init.sh script
COPY --chown=phantom:phantom recipes $HOME/recipes
RUN chown -R phantom:phantom ${HOME}

WORKDIR $HOME/app
