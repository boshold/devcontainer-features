verify_is_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
  fi
}

install_dependencies() {
  local id="$(grep -E 'ID=' /etc/os-release | cut -d '=' -f 2-)"
  local id_like="$(grep -E 'ID_LIKE=' /etc/os-release | cut -d '=' -f 2-)"

  # Get an adjusted ID independent of distro variants
  if [ "${id}" = "debian" ] || [ "${id_like}" = "debian" ]; then
    install_debian_dependencies;
  else
    echo "Linux distro ${id} not supported. Please create a new issue: https://github.com/boshold/devcontainer-features/issues/new"
    exit 1
fi
}

# dependencies for debian / ubuntu
install_debian_dependencies() {
  # May someone already updated it for us - Thx 2 you
  local last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
  local now=$(date +%s)
  if [ $((now - last_update)) -gt 3600 ]; then
    apt-get update -y
  else
    echo "Skip 'apt-get update' since it was already updated in the last 60 minutes".
  fi

  apt-get -y install ninja-build gettext cmake unzip curl build-essential jq

  apt-get -y clean
  rm -rf /var/lib/apt/lists/*
}

# helper function to get valid tags. Will make it public using TAG_NAME
get_valid_tag() {
  local tag="$1"

  # Remove 'v' prefix if present
  case $tag in
    v*) tag=${tag#v} ;;
  esac

  # Get the list of valid releases from GitHub
  local valid_tags="$(curl -s -X GET "https://api.github.com/repos/$REPOSITORY/releases" | jq -r '.[] | .tag_name')"

  # Check if the provided tag is valid
  for valid_tag in $valid_tags; do
    local valid_patch=$valid_tag
    local valid_minor=${valid_tag%.*}
    local valid_major=${valid_tag%%.*}
    if  [ "$valid_tag" = "$tag" ] ||
        [ "$valid_patch" = "v$tag" ] || 
        [ "$valid_minor" = "v$tag" ] || 
        [ "$valid_major" = "v$tag" ] ;then
      RESULT=$valid_tag
      return 0
    fi
  done

  RESULT=""
  return 1
}
