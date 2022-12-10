#*****************************************************************************#
# Author:                                                                     #
# Created Date:                                                               #
# Description:																  #															
#*****************************************************************************#


#-----------------------------------------------------------------------------#
#                        User Definable Parameters                            #
#-----------------------------------------------------------------------------#

$log_location="C:\Windows\ccmcache\$($env:COMPUTERNAME)_Azure_Storage_Explore.txt"
$DEBUG = "True"

#-----------------------------------------------------------------------------#
#               End User Definable Parameters                                 #
#-----------------------------------------------------------------------------#

if($DEBUG) {echo "*****************************************************"}
if($DEBUG) {echo "*    Starting Script                                *"}
if($DEBUG) {echo "*    Date Started: $(Get-Date)              *"}
if($DEBUG) {echo "*****************************************************"}
echo "*****************************************************" >> $log_location
echo "*    Starting Script                                *" >> $log_location
echo "*    Date Started: $(Get-Date)              *"         >> $log_location
echo "*****************************************************" >> $log_location


if($DEBUG) {echo "---------------------------------"}
if($DEBUG) {echo "| PRINT_VARIABLES               |"}
if($DEBUG) {echo "---------------------------------"}
echo "---------------------------------" >> $log_location
echo "| PRINT_VARIABLES               |" >> $log_location
echo "---------------------------------" >> $log_location

echo "log_location=$($log_location)"
echo "log_location=$($log_location)" >> $log_location

if($DEBUG) {echo "---------------------------------"}
if($DEBUG) {echo "| END_PRINTING_VARIABLES        |"}
if($DEBUG) {echo "---------------------------------"}
echo "---------------------------------" >> $log_location
echo "| END_PRINTING_VARIABLES        |" >> $log_location
echo "---------------------------------" >> $log_location

echo "Installation has started"
echo "Installation has started" >> $log_location

#Start installation Process
Start-Process -Wait -FilePath .\StorageExplorer.exe -ArgumentList "/silent"

$installation_status=$?

echo "Installation result -> $installation_status" 
echo "Installation result -> $installation_status" >> $log_location


if($DEBUG) {echo "********************************************"}
if($DEBUG) {echo "         END $(Get-Date)                    "}
if($DEBUG) {echo "********************************************"}
echo "********************************************" >> $log_location
echo "         END $(Get-Date)                    " >> $log_location
echo "********************************************" >> $log_location