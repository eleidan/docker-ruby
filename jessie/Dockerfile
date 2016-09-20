FROM eleidan/buildpack-deps:jessie
MAINTAINER Oleg Kulyk

ENV RBENV_VERSION=2.1.2
ENV SERVICE_NAME="ruby:$RBENV_VERSION" \
    HOME=/root

ARG RBENV_PATH="$HOME/.rbenv"
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_PATH \
    && git clone https://github.com/rbenv/ruby-build.git $RBENV_PATH/plugins/ruby-build \
    && cd $RBENV_PATH \
    && src/configure && make -C src \
    && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc \
    && bin/rbenv install $RBENV_VERSION

WORKDIR /usr/src/app

CMD ["bash"]
