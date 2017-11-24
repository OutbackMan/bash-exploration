#!/usr/bin/env bash

readonly TITLE="git-sync"
readonly VERSION="0.0.1"
readonly DESCRIPTION="Keeps git repositories up to date"
readonly USAGE="$TITLE [OPTION]... [URL]..." 
readonly AUTHOR="Russell Coight <rj.coight@gmail.com>"
readonly DATE_OF_CREATION="24th of November, 2017"

declare -Ar SHORT_TO_LONG_OPT=( ["h"]="help" ["v"]="version" )
declare -Ar OPT_HANDLER=( ["h"]="help_opt" ["v"]="version_opt" )

print_help() {
  printf "$TITLE $VERSION. $DESCRIPTION.\n"  
  printf "Usage: $USAGE\n"
  printf "\n.......\n"
  printf "\nCreated on $DATE_OF_CREATION by $AUTHOR.\n"
}

#@ ARGUMENTS:
#@	$1 = Invalid option
print_invalid_option() {
  printf "$TITLE: invalid option -- '$1'\n"  
  printf "Usage: $USAGE\n"
  printf "\nTry '$TITLE --help' for more options.\n"
}

#@ ARGUMENTS:
#@	$1 = Option requiring argument
print_option_requires_argument() {
  printf "${TITLE}: option requires an argument -- '$1'\n"  
  printf "Usage: $USAGE\n"
  printf "\nTry '$TITLE --help' for more options.\n"
}

#@ ARGUMENTS:
#@	$1 = Option
#@  $2 = Invalid option argument 
print_invalid_option_argument() {
  # Function that returns a string indicating error
  printf "$TITLE: --${SHORT_TO_LONG_OPT[$1]}: Invalid number '$2'" 
  #  
}

## option, option argument, operand
## each call will use the next positional parameter and possible argument
## stops on first operand

## Parsing arguments
## Silent error reporting mode (\?==invalid option, :==required argument not found)
## Must manually disallow identical options
OPTSPEC=":hv-p:"

## Defaults to $@ but could parse explicit array
while getopts "$OPTSPEC" OPTCHAR; do
  case "$OPTCHAR" in
	h)
	  print_help
	  exit 0
	  ;;
	v)
	  printf "$VERSION\n"
	  exit 0
	  ;;
	:)
	  printf "$OPTARG requires an argument\n"
	  exit 1
    -)
	  case "$OPTARG" in
		version)
		  printf "$VERSION\n"
		  exit 0
		  ;;
		help)
		  print_help
		  exit 0
		  ;;
		*)
		  print_invalid_option "$OPTARG"
	  esac
	*)
	  print_invalid_option "$OPTCHAR" 
  esac	
done

case $optchar in
  r)
    _process_r_opt $OPTARG 
    ;;
  repeat=* | repeat)
	OPTARG=""
	_process_r_opt $OPTARG
	;;
  
esac

_process_r_opt() {
## Check if processing a duplicate argument
  if [ -z ${_PROCESS_R_OPT+x} ]; then
	_PROCESS_R_OPT=1
  else
    return 0
  fi 
## $1 == empty --> must have passed long option with no argument
## Could also be checking if passed an argument when not expected
  if [ -z "$1" ]; then
    printf "requires argument" # redirect to stderr
	exit 1
  elif [ "$1" -lt 0 ]; then
    printf "invalid argument value"
	exit 2
  else
	return 0
  fi  
}

if [ ! _process_r_opt "${OPTARG}" ]; then
	printf "Error processing r option\n"
fi 

# main "$@"
