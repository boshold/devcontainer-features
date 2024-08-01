semver_parse_rule() {
  local prefix="$1"
  local raw_rule="$2"
  declare -g "${prefix}_SEMVER_RANGE="
  declare -g "${prefix}_SEMVER_MAJOR="
  declare -g "${prefix}_SEMVER_MINOR="
  declare -g "${prefix}_SEMVER_PATCH="

  
}

semver_parse_rule "LEFT" "^1.0.0"

echo $LEFT_SEMVER_RANGE
