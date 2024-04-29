_normalize() {
  cat | tr ' .:' '-' | tr '[:upper:]' '[:lower:]'
}

# helper functions
get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

session_name() {
  if [ "$1" = "--directory" ]; then
    shift
    basename "$@" | _normalize
  elif [ "$1" = "--full-path" ]; then
    shift
    echo "$@" | _normalize | sed 's/\/$//'
  elif [ "$1" = "--short-path" ]; then
    shift
    echo "$(echo "${@%/*}" | sed -r 's;/([^/]{1,2})[^/]*;/\1;g' | _normalize)/$(basename "$@" | _normalize)"
  else
    echo "Wrong argument, you can use --directory, --full-path or --short-path, got $1"
    return 1
  fi
}
