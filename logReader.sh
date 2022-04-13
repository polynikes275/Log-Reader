#!/bin/zsh

# Author: Jason Brewer
# A bash script that parses a log file, greps out what content you are searching for, and uses espeak to say the alert message back to you

# Get name of script
scriptname=$(basename $0)

# If cmd line args equal 0
if (( $# == 0 ))
then
printf "\n[NOTE]: This script uses espeak to repeat your message back to you\n\n[!!!]\tUse '-h' for the help menu\n"
exit
fi

# Help function that prints out usage info
function help {

printf "\n[NOTE]: This script uses espeak to repeat your message back to you\n\n[Usage] ./$scriptname -l logfile -c 'content to grep' -m 'message to say'\n"
exit

}

# While loop for command line args
while (( $# > 0 )) && (( $# == 6 ))
do

LOGFILE=""
CONTENT=""
MESSAGE=""

while getopts :c:hl:m: arg ; do

    case "${arg}" in
        l)
            LOGFILE=${OPTARG} 
            ;;

        c)
            CONTENT=${OPTARG} 
            ;;

        m)
            MESSAGE=${OPTARG}
            ;;
            
        h)
            help
            ;;
	*)
	    help
	    ;;

    esac
done
shift $(($OPTIND -1)) 
done

# If any of the 3 variables are empty show help menu; if not, run the function
if [ -z "${LOGFILE}" ] || [ -z "${CONTENT}" ] || [ -z "${MESSAGE}" ]
then
help
exit
else
function runCMD {

while true ; do count=1; sudo tail -f "${LOGFILE}" | grep -i --line-buffered -e "${CONTENT}" | while read line; do if [[ $count -ne 10 ]]; then ((count+=1)) ; fi; if [[ $count == 10 ]]; then  espeak "${MESSAGE}" ; break; fi ; done; done

}
fi

runCMD
