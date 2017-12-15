#!/bin/sh

DOCKER_DIR=".docker"

DOCKER_FILES_DIR="$HOME/recipes"
echo "Copying files from $DOCKER_FILES_DIR (container) to project directory (host) ..." \
  && cp -r $DOCKER_FILES_DIR/* . \
  && echo "Done."

echo "Copying files from $HOME to $DOCKER_DIR ..." \
  && cp $HOME/.bash_history $DOCKER_DIR \
  && echo "Done."
