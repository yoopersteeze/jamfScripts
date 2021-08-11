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
# This script will send a command to UnmanageComputer to a desired computer group
# Most credits go to github dot com slash kc9wwh
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

jamfProURL=""
jamfUser=""					                    	
jamfPass=""
computerGroupID=""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

deviceIDs=$( curl -k -s -u "$jamfUser":"$jamfPass" $jamfProURL/JSSResource/computergroups/id/$computerGroupID -H "Accept: application/xml" -X GET | xpath -q -e "//computer_group/computers/computer/id/text()")
for i in ${deviceIDs[@]}; do
    echo "Sending Remove MDM Command to Computer ID: $i..."
    /usr/bin/curl -sk -u "$jamfUser":"$jamfPass" -H "Content-Type: text/xml" $jamfProURL/JSSResource/computercommands/command/UnmanageDevice/id/"$i" -X POST > /dev/null
    if [[ "$?" == "0" ]]; then
        echo "   Command Processed Successfully"
    else
        echo "   Error Processing Command"
    fi
    echo ""
done

sleep 10

/usr/local/bin/jamf mdm


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# CLEANUP & EXIT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

exit 0
