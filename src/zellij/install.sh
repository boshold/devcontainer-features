#!/bin/sh
set -e

if [ -f "./.global" ]; then
  GLOBAL_DEPENCENCIES="./.global"
else
  GLOBAL_DEPENCENCIES="../_global"
fi

. $GLOBAL_DEPENCENCIES/util.sh
. $GLOBAL_DEPENCENCIES/nerdfont.sh
. $GLOBAL_DEPENCENCIES/github.sh
. $GLOBAL_DEPENCENCIES/dependencies.sh
. ./functions.sh

main() {
  # Get options
  local mode=${MODE:-"auto"}
  local version=${VERSION:-"stable"}
  local repository=${REPOSITORY:-"neovim/neovim"}
  local configRepository=${CONFIG:-""}
  local configHookEnabled=${CONFIG_HOOK:-"true"}
  local installNerdFont=${NERDFONT:-"false"}
  local installLazyGit=${LAZYGIT:-"false"}

  if [ "$version" = "latest" ]; then
    version="stable"
  fi

  echo "Installing feature 'neovim' using the passed configuration:"
  echo "  Mode: ${mode}"
  echo "  Version: ${version}"
  echo "  Repository: ${repository}"
  echo "  Config repository: ${configLocation}"
  echo "  Config hook enabled: ${configHookEnabled}"
  echo "  Install NerdFont: ${installNerdFont}"
  echo "  Install LazyGit: ${installLazyGit}"

  util_start_time_measure

  # Verify that current user is root
  util_verify_is_root

  if [ "$mode" = "auto" ]; then
    # local install_version=`dependencies_get_version_debian "neovim" && util_result`
    install_neovim_source "$repository" "$version"
  elif [ "$mode" = "apt" ]; then
    install_neovim_apt
  elif [ "$mode" = "source" ]; then
    install_neovim_source "$repository" "$version"
  fi

  echo 'Running `nvim -v`:'
  nvim -v

  util_end_time_measure;
  local runtime="$RESULT"

  echo "Installed '$version' as '${repository}:${tagName}' successfully (in only ${RUNTIME}s)!"


  if [ "$installNerdFont" = "true" ]; then
    # TODO: Support multiple nerd fonts
    echo "Installing Nerdfont"
    nerdfont_install "JetBrainsMono";
  fi

  if [ ! "$configLocation" = "" ]; then

  fi;

}
main;
