util_verify_is_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
  fi
  return 0
}

util_read_value_from_properties_file() {
  local file="$1"
  local property="$2"
  local value=$(grep -E "^${property}=" $file | cut -d '=' -f 2-)
  RESULT="$value"
}

util_start_time_measure() {
  local startTime=`date +%s`

  UTIL_START_TIME=$startTime
  RESULT=$startTime
}

util_end_time_measure() {
  local startTime="${1:-$UTIL_START_TIME}"
  local endTime=`date +%s`
  local runtime=$((endTime-startTime))

  RESULT=$runtime
}

util_result() {
  echo $RESULT
}

util_check_version() {
  local version="$1"
  local versionRange="$2"

  local version_patch=$version
  local version_minor=${version%.*}
  local version_major=${version%%.*}

  if  [ "$version" = "$versionRange" ] ||
      [ "$version_patch" = "$versionRange" ] || 
      [ "$version_minor" = "$versionRange" ] || 
      [ "$version_major" = "$versionRange" ] ;then
    RESULT="true"
    return 0
  fi

  RESULT="false"
  return 1;
}
