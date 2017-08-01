#!/bin/sh

DOCKER_DIR=".docker"

RUBY_DIR="$DOCKER_DIR/ruby"
RBENV_DIR="$HOME/.rbenv/versions/2.4.0"
echo "Copying files from $RBENV_DIR (container) to $RUBY_DIR (host) ..." \
  && mkdir -p $RUBY_DIR \
  && cp -r $RBENV_DIR/* $RUBY_DIR \
  && echo "Done."

DOCKER_FILES_DIR="$HOME/recipes"
echo "Copying files from $DOCKER_FILES_DIR (container) to project directory (host) ..." \
  && cp -r $DOCKER_FILES_DIR/* . \
  && echo "Done."

echo "Copying files from $HOME to $DOCKER_DIR ..." \
  && cp $HOME/.bash_history $DOCKER_DIR \
  && echo "Done."
