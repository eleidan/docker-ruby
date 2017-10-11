#!/usr/bin/env bash

# Copy existing one as a base for another version
RUBY_VERSION=$1
DISTRO_FAMILY=$2
DISTRO_RELEASE=$3

BASE_DISTRO_RELEASE="jessie"
case $DISTRO_FAMILY in
  ubuntu )
    BASE_DISTRO_RELEASE="16.04"
    ;;
  centos )
    BASE_DISTRO_RELEASE="6.6"
    ;;
esac
NEW_RUBY_PATH="${RUBY_VERSION}/${DISTRO_FAMILY}/${DISTRO_RELEASE}"
BASE_RUBY_PATH="2.2.2/${DISTRO_FAMILY}/${BASE_DISTRO_RELEASE}"
mkdir -p ${NEW_RUBY_PATH}
cp -r ${BASE_RUBY_PATH}/* ${NEW_RUBY_PATH}/

TARGET_FILE="${NEW_RUBY_PATH}/Dockerfile"
sed -i -r \
    -e "s/$BASE_DISTRO_RELEASE/${DISTRO_RELEASE}/g" \
    -e "s/version=\S*/version=\"$(date +"%F")\"/g" \
    ${TARGET_FILE}

SEMVER_PATTERN="[0-9]+\.[0-9]+\.[0-9]+"

TARGET_FILE="${NEW_RUBY_PATH}/docker-init.sh"
sed -i -r \
    -e "s|versions/${SEMVER_PATTERN}|versions/${RUBY_VERSION}|g" \
    ${TARGET_FILE}

TARGET_FILE="${NEW_RUBY_PATH}/Dockerfile"
sed -i -r \
    -e "s/Ruby ${SEMVER_PATTERN}/Ruby ${RUBY_VERSION}/g" \
    -e "s/ruby:${SEMVER_PATTERN}/ruby:${RUBY_VERSION}/g" \
    -e "s/RBENV_VERSION=${SEMVER_PATTERN}/RBENV_VERSION=${RUBY_VERSION}/g" \
    -e "s/version=\S*/version=\"$(date +"%F")\"/g" \
    ${TARGET_FILE}

TARGET_FILE="${NEW_RUBY_PATH}/recipes/docker-compose.yml"
sed -i -r \
    -e "s|versions/${SEMVER_PATTERN}|versions/${RUBY_VERSION}|g" \
    ${TARGET_FILE}

TARGET_FILE="${NEW_RUBY_PATH}/recipes/Dockerfile"
sed -i -r \
    -e "s/ruby:${SEMVER_PATTERN}/ruby:${RUBY_VERSION}/g" \
    -e "s/$BASE_DISTRO_RELEASE/${DISTRO_RELEASE}/g" \
    ${TARGET_FILE}
