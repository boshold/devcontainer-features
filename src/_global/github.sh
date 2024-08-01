github_get_valid_tag() {
  local repository="$1"
  local tag="$2"

  # Remove 'v' prefix if present
  case $tag in
    v*) tag=${tag#v} ;;
  esac

  # Get the list of valid releases from GitHub
  local valid_tags="$(curl -s -X GET "https://api.github.com/repos/$repository/releases" | jq -r '.[] | .tag_name')"

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

github_get_latest_release() {
  local repository="$1"
  local latest_tag="$(curl -s -X GET "https://api.github.com/repos/$repository/releases" | jq -r '.[0] | .tag_name')"
  RESULT=$latest_tag
  return 0;
}

github_get_latest_tag() {
  local repository="$1"
  local latest_tag="$(curl -s -X GET "https://api.github.com/repos/$repository/tags" | jq -r '.[0] | .name')"
  RESULT=$latest_tag
  return 0;
}
