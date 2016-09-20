FROM eleidan/buildpack-deps:jessie
MAINTAINER Oleg Kulyk

ENV RBENV_VERSION=2.1.2
ENV SERVICE_NAME="ruby:$RBENV_VERSION" \
    HOME=/root

WORKDIR $HOME/.rbenv

RUN git clone https://github.com/rbenv/rbenv.git \
    && git clone https://github.com/rbenv/ruby-build.git plugins/ruby-build \
    && src/configure && make -C src \
    && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
    && bin/rbenv install $RBENV_VERSION

WORKDIR /usr/src/app

CMD ["bash"]
