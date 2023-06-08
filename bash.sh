#! /usr/bin/env bash
#
# Based on https://github.com/bertvv/dotfiles/blob/main/.vim/templates/sh
# and https://betterdev.blog/minimal-safe-bash-script-template/
#

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail

# https://www.baeldung.com/linux/ifs-shell-variable
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)

script_name=$(basename "${0}")
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly script_name script_dir

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -f | --flag) flag=1 ;; # example flag
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${param-}" ]] && die "Missing required parameter: param"
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

main() {
  printf "This is main\n"
  # main script here
}

parse_params "$@"
main "${@}"

msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"