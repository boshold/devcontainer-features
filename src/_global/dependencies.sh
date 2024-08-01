dependencies_install_debian() {
  local dependencies="$1"
  
  apt-get update -y
  apt-get -y install $dependencies
  apt-get -y clean
  rm -rf /var/lib/apt/lists/*
}

dependencies_get_version_debian() {
  local dependency="$1"
  local version="$(apt-cache show neovim | awk -F ': ' '/^Version:/{print $2}')"
  RESULT="$version"
}
