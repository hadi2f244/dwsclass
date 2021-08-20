#!/bin/bash
set -euo pipefail

# Static Values
nre='^[0-9]+$'

verboose=0

# ignore 'try' keyword
if [ $1 == "try" ]; then
    shift
fi


if:IsSet() {
  [[ ${!1-x} == x ]] && return 1 || return 0
}

ValidateNumArg()  # value, name
{
    if [ ! "$1" ]; then
        echo "Argument $2 must be provided. Enter -h for more informations."
        exit 1;
    fi
    if ! [[ $1 =~ $nre ]] ; then
        echo -e "Argument $2 must be \033[4mnumber\033[0m (value: $1). Enter -h for more informations."
        exit 1;
    fi
}

Help()
{
   # Display Help
   echo -e "\033[1mtry\033[0m is bash compatible command that try to run a \033[4mcommand\033[0m repeatedly until the return code is not zero.  If it fails n times, an error occurs and it exits with 1 status code."
   echo
   echo -e "Syntax: try [-i|-n|-h|-v] \033[4mcommand\033[0m"
   echo -e "Options:"
   echo -e "    -n\n    number of tries."
   echo -e "    -i  \033[4mseconds\033[0m \n    interval between each try."
   echo -e "    -v\n        verboose"
   echo -e "    -h\n        help"
   echo
}


# Check arguments and rewrite provided arguments
while getopts "hn:i:v" OPTION; do
  case $OPTION in
    h) # display Help
        Help
        exit
        ;;
    n)
        nvalue="$OPTARG"
        ;;
    i)
        ivalue="$OPTARG"
        ;;
    v) 
        verboose=1
        ;;
    \?) valid=0
        Help;
        exit 1
        ;;
   esac
done
shift "$(($OPTIND -1))"


# Argument Validations
if:IsSet ivalue || $(echo "Argument -i must be provided. Enter -h for more informations."; exit 1;)
if:IsSet nvalue || $(echo "Argument -n must be provided. Enter -h for more informations."; exit 1;)
ValidateNumArg $ivalue "-i" || 
ValidateNumArg $nvalue "-n"

# remaining arguments are taken as command
command=$@

# verboose
if [ $verboose -ne 0 ]; then
    echo "Number: $nvalue"
    echo "Interval: $ivalue"
    echo "Command: $command"
fi


for i in $(seq 1 $nvalue); do
    status=0
    $command || status=1
    if [ $status == 0 ]; then
        exit 0
    else
        if [ $i == $nvalue ]; then
            >&2 echo "Can not run command by the specified try_interval and try_number."
            exit 1
        else
            sleep $ivalue
        fi
    fi
done