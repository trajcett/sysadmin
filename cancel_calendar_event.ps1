#*****************************************************************************#
# Author:                                                                     #
# Created Date: 12.01.2022                                                    #
# Description:																  #															
#*****************************************************************************#


Import-Module MSAL.PS
Import-Module Microsoft.Graph.Calendar

#-----------------------------------------
#    User Definable Parameters
#-----------------------------------------


#-----------------------------------------
#    End User Definable Parameters
#-----------------------------------------


function check_usage 
{
    echo "Usage:"
    echo ".\outlook_holiday_graphapi.ps1 UserID/UPN"

    echo "Example:"
    echo ".\Run_Client_Actions.ps1 ooo@apsengl.com"    
}

if ($args.Count -lt 1)
{
    check_usage
    exit

} elseif ($args[0] -eq '-h')
{
    check_usage
    exit
}

$AppId = '0fda04ec-ed43-42ed-82f5-854052bfe83c'
$TenantId = '8bec29a0-16eb-4d7b-ba85-de660fbf2726'
$ClientSecret = 'fuK8Q~fkqF2zhfStRV0VKPtoSL1.14RVX.qozbFI'

echo "#-----------------------------------"
echo "# Assign User ID"
echo "#-----------------------------------"
echo ""

$userid = $args[0]

echo "->userid = $userid"
echo ""


echo "------------------------------------"
echo "# Get Access Token"
echo "#-----------------------------------"
echo ""

#$MsalToken = Get-MsalToken -TenantId '8bec29a0-16eb-4d7b-ba85-de660fbf2726' -ClientId '0fda04ec-ed43-42ed-82f5-854052bfe83c' -ClientSecret ('fuK8Q~fkqF2zhfStRV0VKPtoSL1.14RVX.qozbFI' | ConvertTo-SecureString -AsPlainText -Force)
$MsalToken = Get-MsalToken -TenantId $TenantId -ClientId $AppId -ClientSecret ($ClientSecret | ConvertTo-SecureString -AsPlainText -Force)
$tokenvalue = $MsalToken.AccessToken

echo "->Token = $MsalToken.AccessToken"
echo ""
 
echo "------------------------------------"
echo "# Connect to Graph API"
echo "#-----------------------------------"
echo ""

#Connect to Graph using access token
Connect-Graph -AccessToken $MsalToken.AccessToken
echo ""

echo "------------------------------------"
echo "# Get Calendar ID from the User ID  "
echo "#-----------------------------------"
echo ""

$result = Get-MgUserEvent -All -UserId $userId -Property "subject,body,bodyPreview,organizer,attendees,start,end,location" 
$result 

echo $result > result.txt

<#
#Collect Calendar ID for the specified User
$calendarid = $(Get-MgUserCalendar -UserId $userid).Id
echo "->calendarid = $calendarid"

Get-MgUserCalendarPermission -UserId $userid

Get-MgUserMailFolder -UserId $userid
#>