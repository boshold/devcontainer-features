install_dependencies() {
  local id=`util_read_value_from_properties_file "/etc/os-release" "ID"; util_result`;
  local id_like=`util_read_value_from_properties_file "/etc/os-release" "ID_LIKE"; util_result`;

  # Get an adjusted ID independent of distro variants
  if [ "${id}" = "debian" ] || [ "${id_like}" = "debian" ]; then
    dependencies_install_debian curl jq zip g++ libssl-dev pkg-config make
    
  else
    echo "Linux distro ${id} not supported. Please create a new issue: https://github.com/boshold/devcontainer-features/issues/new"
    exit 1
  fi
}

install_zellij_source() {
  local repository="$1"
  local version="$2"

  # Install required dependencies
  install_dependencies
  
  # Get the correct tag for the passed in version
  
  local tag_name=`github_get_valid_tag "$repository" "$version" && util_result`
  if [ $tag_name = "" ]; then
    # If the tag is not found, return an error message
    echo "No tag found in '$repository' for the provided version: $version" >&2
    exit 1
  fi

  echo "The tag to be installed is '$tag_name' (https://github.com/${repository}/releases/tag/${tag_name})"
  local local_temp_folder="/tmp/source-neovim-${tag_name}"
  rm -rf $local_temp_folder
  mkdir $local_temp_folder

  # Download neovim
  echo "Downloading source for ${repository}:${tag_name}..."
  curl -sL https://github.com/${repository}/archive/refs/tags/${tag_name}.tar.gz | tar -xzC "$local_temp_folder" --strip-components=1 2>&1

  # Build neovim
  echo "Building..."
  cd "$local_temp_folder"
  make && make CMAKE_INSTALL_PREFIX=/usr/local/nvim install
  ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

  # Clean up
  rm -rf "$local_temp_folder"
}

install_zellij_binary() {
 ocal repository="$1"
  local version="$2"

  # Install required dependencies
  install_dependencies
  
  # Get the correct tag for the passed in version
  
  local tag_name=`github_get_valid_tag "$repository" "$version" && util_result`
  if [ $tag_name = "" ]; then
    # If the tag is not found, return an error message
    echo "No tag found in '$repository' for the provided version: $version" >&2
    exit 1
  fi

  echo "The tag to be installed is '$tag_name' (https://github.com/${repository}/releases/tag/${tag_name})"
  local local_temp_folder="/tmp/source-neovim-${tag_name}"
  rm -rf $local_temp_folder
  mkdir $local_temp_folder

  # Download neovim
  echo "Downloading source for ${repository}:${tag_name}..."
  curl -sL https://github.com/${repository}/archive/refs/tags/${tag_name}.tar.gz | tar -xzC "$local_temp_folder" --strip-components=1 2>&1

  # Build neovim
  echo "Building..."
  cd "$local_temp_folder"
  make && make CMAKE_INSTALL_PREFIX=/usr/local/nvim install
  ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

  # Clean up
  rm -rf "$local_temp_folder"
}

install_zellij_cargo() {
 ocal repository="$1"
  local version="$2"

  # Install required dependencies
  install_dependencies
  
  # Get the correct tag for the passed in version
  
  local tag_name=`github_get_valid_tag "$repository" "$version" && util_result`
  if [ $tag_name = "" ]; then
    # If the tag is not found, return an error message
    echo "No tag found in '$repository' for the provided version: $version" >&2
    exit 1
  fi

  echo "The tag to be installed is '$tag_name' (https://github.com/${repository}/releases/tag/${tag_name})"
  local local_temp_folder="/tmp/source-neovim-${tag_name}"
  rm -rf $local_temp_folder
  mkdir $local_temp_folder

  # Download neovim
  echo "Downloading source for ${repository}:${tag_name}..."
  curl -sL https://github.com/${repository}/archive/refs/tags/${tag_name}.tar.gz | tar -xzC "$local_temp_folder" --strip-components=1 2>&1

  # Build neovim
  echo "Building..."
  cd "$local_temp_folder"
  make && make CMAKE_INSTALL_PREFIX=/usr/local/nvim install
  ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

  # Clean up
  rm -rf "$local_temp_folder"
}
