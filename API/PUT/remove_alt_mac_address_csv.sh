#!/bin/bash

####################################################################################################
#
# THIS SCRIPT IS NOT AN OFFICIAL PRODUCT OF JAMF SOFTWARE
# AS SUCH IT IS PROVIDED WITHOUT WARRANTY OR SUPPORT
#
# BY USING THIS SCRIPT, YOU AGREE THAT JAMF SOFTWARE
# IS UNDER NO OBLIGATION TO SUPPORT, DEBUG, OR OTHERWISE
# MAINTAIN THIS SCRIPT
#
####################################################################################################
#
# DESCRIPTION
# This script will read in parameters and remove the alt_mac_address from a specified csv list of computerIDs
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

read -p "Jamf Pro URL: " server
read -p "Jamf Pro Username: " username
read -s -p "Jamf Pro Password: " password
echo ""
read -p "Please drag and drop the csv into this window and hit enter: " computerList

####################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
# Courtesy of github dot com slash iMatthewCM
#Read CSV into array
IFS=$'\n' read -d '' -r -a computerIDs < $computerList

length=${#computerIDs[@]}

#Do all the things
for ((i=0; i<$length;i++));

do
	id=$(echo ${computerIDs[i]} | sed 's/,//g' | sed 's/ //g'| tr -d '\r\n')
	curl -ksu "$username":"$password" -H "content-type: application/xml" "$server"/JSSResource/computer/id/"$id" -X PUT -d "<computer><general><alt_mac_address></alt_mac_address></general></computer>"
done
