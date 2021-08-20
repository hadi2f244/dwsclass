#!/bin/bash
set -euo pipefail


# Static Values
nre='^[0-9]+$'
nvalue_default=10
ivalue_default=15

verboose=0

# ignore 'try' keyword
if [ $1 == "try" ]; then
    shift
fi

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
   echo -e "\n\033[1mtry\033[0m is bash compatible command that try to run a \033[4mcommand\033[0m repeatedly until the return code is not zero. By default, \
\033[4mcommand\033[0m is run 10 times and there is a 15 second delay between each. If it fails n times, an error occurs and it exits with 1 status code."
   echo
   echo -e "Syntax: try [-i|-n|-h|-v] \033[4mcommand\033[0m"
   echo -e "Options:"
   echo -e "    -n\n        number of tries. ‫‪\033[3mTRY_NUMBER‬‬\033[0m can be used alternatively as a environment variable. Default: 10"
   echo -e "    -i  \033[4mseconds\033[0m \n        interval between each try. ‫‪\033[3mTRY_INTERVAL\033[0m can be used alternatively as a environment variable. Default: 15"
   echo -e "    -v\n        verboose"
   echo -e "    -h\n        help"
   echo -e "You can use \033[3mTRY_COMMAND\033[0m environment variable to enter a \033[4mcommand\033[0m."
}

# Check env variables and set default value for empty variables 
# [[ -z "${TRY_INTERVAL}" ]] && ivalue=$ivalue_default || ivalue="${TRY_INTERVAL}"
# [[ -z "${TRY_NUMBER}" ]] && nvalue=$nvalue_default || nvalue="${TRY_NUMBER}"

ivalue=${TRY_INTERVAL-$ivalue_default}
nvalue=${TRY_NUMBER-$nvalue_default}

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
shift "$(($OPTIND -1))"  ###?
# https://serverfault.com/questions/95077/how-can-i-get-remaining-args-after-pulling-out-parsed-items-using-getopts
# https://linuxconfig.org/how-to-use-getopts-to-parse-a-script-options



# Argument Validations
ValidateNumArg $ivalue "-i"
ValidateNumArg $nvalue "-n"


# remaining arguments are taken as command
command=$@

# Check 'command' is empty
if [ $# -eq 0 ];then
    # check existance of TRY_COMMAND and raise an error if it doesn't
    [[ -z "${TRY_COMMAND}" ]] && echo -e "\033[4mcommand\033[0m is not provided. Enter -h for more informations." || command="${TRY_COMMAND}"
fi

if [ $verboose -ne 0 ]; then
    echo "Number: $nvalue"
    echo "Interval: $ivalue"
    echo "Command: $command"
fi


# Main loop to run command repeatedly 
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