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
  printf "$TITLE: option requires an argument -- '$1'\n"  
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

## Parsing arguments
OPTSPEC="hv-p:"

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


