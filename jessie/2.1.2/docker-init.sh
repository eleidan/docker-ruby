#!/bin/sh

DOCKER_DIR=".docker"

RUBY_DIR="$DOCKER_DIR/ruby"
RBENV_DIR="$HOME/.rbenv/versions/2.1.2"
echo "Copying files from $RBENV_DIR (container) to $RUBY_DIR (host) ..." \
  && mkdir -p $RUBY_DIR \
  && cp -r $RBENV_DIR/* $RUBY_DIR \
  && echo "Done."

SCRIPTS_DIR="$DOCKER_DIR/scripts"
CONTAINER_SCRIPTS_DIR="$HOME/scripts"
echo "Copying files from $CONTAINER_SCRIPTS_DIR (container) to $SCRIPTS_DIR (host) ..." \
  && mkdir -p $SCRIPTS_DIR \
  && cp -r $CONTAINER_SCRIPTS_DIR/* $SCRIPTS_DIR \
  && echo "Done."

DOCKER_FILES_DIR="$HOME/recipes"
echo "Copying files from $DOCKER_FILES_DIR (container) to project directory (host) ..." \
  && cp -r $DOCKER_FILES_DIR/* . \
  && echo "Done."

echo "Copying files from $HOME to $DOCKER_DIR ..." \
  && cp $HOME/.bash_history $DOCKER_DIR \
  && echo "Done."
