#!/usr/bin/env bash

# Copy existing one as a base for another version
VER=$1
mkdir $VER
cp -R 2.2.2/* $VER/

SEMVER_PATTERN="[0-9]+\.[0-9]+\.[0-9]+"

TARGET_FILE="${VER}/jessie/Dockerfile"
sed -i -r \
    -e "s/Ruby ${SEMVER_PATTERN}/Ruby ${VER}/g" \
    -e "s/ruby:${SEMVER_PATTERN}/ruby:${VER}/g" \
    -e "s/RBENV_VERSION=${SEMVER_PATTERN}/RBENV_VERSION=${VER}/g" \
    -e "s/version=\S*/version=\"$(date +"%F")\"/g" \
    ${TARGET_FILE}

TARGET_FILE="${VER}/jessie/recipes/docker-compose.yml"
sed -i -r \
    -e "s|versions/${SEMVER_PATTERN}|versions/${VER}|g" \
    ${TARGET_FILE}

TARGET_FILE="${VER}/jessie/recipes/Dockerfile"
sed -i -r \
    -e "s/ruby:${SEMVER_PATTERN}/ruby:${VER}/g" \
    ${TARGET_FILE}

TARGET_FILE="${VER}/jessie/docker-init.sh"
sed -i -r \
    -e "s|versions/${SEMVER_PATTERN}|versions/${VER}|g" \
    ${TARGET_FILE}
