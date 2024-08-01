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
  local value="$(grep -E \"^$property=\" $file | cut -d '=' -f 2-)"
  RESULT=value
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

# util_check_version() {
#   local version="$1"
#   local versionRange="$2"

#   local version_patch=$version
#   local version_minor=${version%.*}
#   local version_major=${version%%.*}

#   if  [ "$version" = "$versionRange" ] ||
#       [ "$version_patch" = "$versionRange" ] || 
#       [ "$version_minor" = "$versionRange" ] || 
#       [ "$version_major" = "$versionRange" ] ;then
#     RESULT="true"
#     return 0
#   fi

#   RESULT="false"
#   return 1;
# }

util_compare_version() {
    local version=$1
    local range=$2

    # Split the version into major, minor, and patch
    local version_parts=(${version//./ })

    # Split the range into its parts (e.g., ^1.2.3)
    local range_parts=(${range//./ })

    # Check if the range is a caret (^) range
    if [[ $range_parts[0] == "^" ]]; then
        # Remove the caret from the range
        range_parts=("${range_parts[@]:1}")

        # Compare major version
        if [[ ${version_parts[0]} -ne ${range_parts[0]} ]]; then
            RESULT="false"
            return
        fi

        # Compare minor version
        if [[ ${version_parts[1]} -lt ${range_parts[1]} ]]; then
            RESULT="false"
            return
        fi

        # If minor version matches or is greater, it's valid
        RESULT="true"
        return
    fi

    # Check if the range is a tilde (~) range
    if [[ $range_parts[0] == "~" ]]; then
        # Remove the tilde from the range
        range_parts=("${range_parts[@]:1}")

        # Compare major and minor versions
        if [[ ${version_parts[0]} -ne ${range_parts[0]} || ${version_parts[1]} -ne ${range_parts[1]} ]]; then
            RESULT="false"
            return
        fi

        # Compare patch version
        if [[ ${version_parts[2]} -ge ${range_parts[2]} ]]; then
            RESULT="true"
            return
        fi

        RESULT="false"
        return
    fi

    # If it's not a caret or tilde range, assume it's an exact match
    if [[ ${version_parts[0]} -eq ${range_parts[0]} && ${version_parts[1]} -eq ${range_parts[1]} && ${version_parts[2]} -eq ${range_parts[2]} ]]; then
        RESULT="true"
        return
    fi

    RESULT="false"
}
