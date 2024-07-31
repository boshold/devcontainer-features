#!/bin/sh
set -e

. ./helper.sh

START_TIME=`date +%s`

echo "Installing feature 'neovim-source'"

# Get input parameter
VERSION=${VERSION:-"stable"}
REPOSITORY=${REPOSITORY:-"neovim/neovim"}

echo "The version to be installed is '$VERSION'"

# Verify that current user is root
verify_is_root

# Install required dependencies
install_dependencies

# Get the correct tag for the passed in version
get_valid_tag "$VERSION"
TAG_NAME="$RESULT"
if [ $TAG_NAME = "" ]; then
  # If the tag is not found, return an error message
  echo "No tag found for the provided version: $VERSION" >&2
  return 1
fi

echo "The tag to be installed is '$TAG_NAME' (https://github.com/${REPOSITORY}/releases/tag/${TAG_NAME})"
LOCAL_TEMP_FOLDER="/tmp/source-neovim-${TAG_NAME}"
rm -rf $LOCAL_TEMP_FOLDER
mkdir $LOCAL_TEMP_FOLDER

# Download neovim
echo "Downloading source for ${REPOSITORY}:${TAG_NAME}..."
curl -sL https://github.com/${REPOSITORY}/archive/refs/tags/${TAG_NAME}.tar.gz | tar -xzC "$LOCAL_TEMP_FOLDER" --strip-components=1 2>&1

# Build neovim
echo "Building..."
cd "$LOCAL_TEMP_FOLDER"
make && make CMAKE_INSTALL_PREFIX=/usr/local/nvim install
ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

# Clean up
rm -rf "$LOCAL_TEMP_FOLDER"

echo 'Running `nvim -v`:'
nvim -v

END_TIME=`date +%s`
RUNTIME=$((END_TIME-START_TIME))
echo "Installed '$VERSION' as '${REPOSITORY}:${TAG_NAME}' successfully (in only ${RUNTIME}s)!"
