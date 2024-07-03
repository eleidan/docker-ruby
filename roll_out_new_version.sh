#!/usr/bin/env bash
################################################################################
PROGRAM=$(basename $0)
read -r -d '' USAGE << EOM
Create release sources based on existing one.

Usage:
  $PROGRAM -r VERSION
  $PROGRAM [--help]

Options:
  -r VERSION            Specify Ruby version to create.
  -h, --help            Print help message.
EOM


################################################################################
function show_usage_and_exit_with_code {
  echo "$USAGE"
  exit $1
}


function process_params {
  if [[ "$1" = "--" ]]; then
    show_usage_and_exit_with_code 1
  fi

  while true; do
    case "$1" in
        -r)
            RELEASE_VERSION="$2"
            shift 2
            ;;
        -h|--help)
            show_usage_and_exit_with_code 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
  done
}


function validate_rust_release_is_specified {
  if [[ "${RELEASE_VERSION}x" = "x" ]]; then
    echo "Error: release is not specified"
    exit 1
  fi
}

function validate_input {
  validate_rust_release_is_specified
}
################################################################################
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

SHORT="r:h"
LONG="help"
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")


if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi

# Flat out parsed params into list of arguments
eval set -- "$PARSED"
################################################################################
function fetch_ruby_major {
  local major=$(echo $1 | cut -f1 -d'.')
  local minor=$(echo $1 | cut -f2 -d'.')
  echo "${major}.${minor}"
}

process_params $@
validate_input
mkdir -p ${RELEASE_VERSION}

SOURCE_VERSION="2.6.5"
SOURCE_VERSION_MAJOR=$(fetch_ruby_major ${SOURCE_VERSION})
RELEASE_VERSION_MAJOR=$(fetch_ruby_major ${RELEASE_VERSION})

SEMVER_PATTERN="[0-9]+\.[0-9]+\.[0-9]+"
ROOT_DIR=$(pwd)
cp -R ${SOURCE_VERSION}/* ${RELEASE_VERSION}/

pushd ${SOURCE_VERSION} > /dev/null
for distro_family in $(ls); do
  pushd $distro_family > /dev/null
  for distro_release in $(ls); do
    TARGET_FILE="${ROOT_DIR}/${RELEASE_VERSION}/${distro_family}/${distro_release}/Dockerfile"
    sed -i -r \
        -e "s/Ruby ${SOURCE_VERSION}/Ruby ${RELEASE_VERSION}/g" \
        -e "s/ruby:${SOURCE_VERSION}/ruby:${RELEASE_VERSION}/g" \
        -e "s/RUBY_VERSION=\"${SOURCE_VERSION}\"/RUBY_VERSION=\"${RELEASE_VERSION}\"/g" \
        -e "s/RUBY_MAJOR=\"${SOURCE_VERSION_MAJOR}\"/RUBY_MAJOR=\"${RELEASE_VERSION_MAJOR}\"/g" \
        -e "s/version=\S*/version=\"$(date +"%F")\"/g" \
        ${TARGET_FILE}

    TARGET_FILE="${ROOT_DIR}/${RELEASE_VERSION}/${distro_family}/${distro_release}/recipes/Dockerfile"
    sed -i -r \
        -e "s/ruby:${SOURCE_VERSION}/ruby:${RELEASE_VERSION}/g" \
        ${TARGET_FILE}
  done
  popd > /dev/null
done
popd > /dev/null
