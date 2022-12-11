#*****************************************************************************#
# Author: Trajce Trajkovski                                                   #
# Created Date: 26.10.2021                                                    #
# Description:																  #															
# Script installs all KB's in the source folder. It waits for the process to  #
# end and checks it the update is installed if not exits with error           #
# TO_DO: load process list from file, accept cmd parameters                   #
#*****************************************************************************#


#-----------------------------------------------------------------------------#
#                        User Definable Parameters                            #
#-----------------------------------------------------------------------------#

#STATIC VARIABLES
$exit_success = 0
$exit_status = 0

$exit_status_1 = 100 #Exit status for no KB present in the folder
$exit_status_2 = 2 #Exit status if the KB is not installed 

$DEBUG = "True"
$wu = $null
$totalupdates = $null
$all = $null

#VARIABLES 
$files = @(Get-ChildItem .\*.msu)  #Get all .msu files in the specified directory
$log_location="C:\Windows\ccmcache\$($env:COMPUTERNAME)_Install_KB.txt"
$KB = @() #Array for storing KB numbers of the updates
$KB_res = @() #Array for storing result of the installation of the KB's
$i = 0 #Temporary variable used in loops

#-----------------------------------------------------------------------------#
#               End User Definable Parameters                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                        FUNCTION DEFINITIONS                                 #
#-----------------------------------------------------------------------------#
function Get-TextWithin {
    <#    
        .SYNOPSIS
            Get the text between two surrounding characters (e.g. brackets, quotes, or custom characters)
        .DESCRIPTION
            Use RegEx to retrieve the text within enclosing characters.
	    .PARAMETER Text
            The text to retrieve the matches from.
        .PARAMETER WithinChar
            Single character, indicating the surrounding characters to retrieve the enclosing text for. 
            If this paramater is used the matching ending character is "guessed" (e.g. '(' = ')')
        .PARAMETER StartChar
            Single character, indicating the start surrounding characters to retrieve the enclosing text for. 
        .PARAMETER EndChar
            Single character, indicating the end surrounding characters to retrieve the enclosing text for. 
        .EXAMPLE
            # Retrieve all text within single quotes
		    $s=@'
here is 'some data'
here is "some other data"
this is 'even more data'
'@
             Get-TextWithin $s "'"
    .EXAMPLE
    # Retrieve all text within custom start and end characters
    $s=@'
here is /some data\
here is /some other data/
this is /even more data\
'@
    Get-TextWithin $s -StartChar / -EndChar \
#>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline = $true,
            Position = 0)]   
        $Text,
        [Parameter(ParameterSetName = 'Single', Position = 1)] 
        [char]$WithinChar = '"',
        [Parameter(ParameterSetName = 'Double')] 
        [char]$StartChar,
        [Parameter(ParameterSetName = 'Double')] 
        [char]$EndChar
    )
    $htPairs = @{
        '(' = ')'
        '[' = ']'
        '{' = '}'
        '<' = '>'
    }
    if ($PSBoundParameters.ContainsKey('WithinChar')) {
        $StartChar = $EndChar = $WithinChar
        if ($htPairs.ContainsKey([string]$WithinChar)) {
            $EndChar = $htPairs[[string]$WithinChar]
        }
    }
    $pattern = @"
(?<=\$StartChar).+?(?=\$EndChar)
"@
    [regex]::Matches($Text, $pattern).Value
}

if($DEBUG) {echo "*************************************************************"}
if($DEBUG) {echo " STARTING SCRIPT          "}
if($DEBUG) {echo " $(Get-Date)                 "}
if($DEBUG) {echo "*************************************************************"}
echo "*************************************************************" >> $log_location
echo " STARTING SCRIPT          " >> $log_location
echo " $(Get-Date)              " >> $log_location
echo "*************************************************************" >> $log_location

if($DEBUG) {echo "*********************************"}
if($DEBUG) {echo "         PRINT VARIABLES         "}
if($DEBUG) {echo "*********************************"}
echo "*********************************" >> $log_location
echo "         PRINT VARIABLES         " >> $log_location
echo "*********************************" >> $log_location

if($DEBUG) {echo log_location=$($log_location)}
echo log_location=$($log_location) >> $log_location

#Check if updates are present in the source folder
if ($files.Count -lt 1)
{
    exit $exit_status_1   
} 

#Run through all of the updates in the folder and install them
if($DEBUG) {echo "--------------------------------------------------------------"}
if($DEBUG) {echo "@Run through all of the updates in the folder and install them"}
if($DEBUG) {echo "--------------------------------------------------------------"}
echo "--------------------------------------------------------------" >> $log_location
echo "@Run through all of the updates in the folder and install them" >> $log_location
echo "--------------------------------------------------------------" >> $log_location

$i=0
foreach ($kb_update in $files)
{
    $KB_value=Get-TextWithin $kb_update.Name -StartChar - -EndChar -
    $KB += $KB_value
    if($DEBUG) { echo "Installing $($KB[$i])...." }
    echo "Installing $($KB[$i])...." >> $log_location
       
    Start-Process $kb_update.Name -argumentlist "/quiet /norestart" -wait
    $i=$i+1
}


if($DEBUG) {echo "--------------------------------------------------------------"}
if($DEBUG) {echo "@Check if the updates are installed                           "}
if($DEBUG) {echo "--------------------------------------------------------------"}
echo "--------------------------------------------------------------" >> $log_location
echo "@Check if the updates are installed                           " >> $log_location
echo "--------------------------------------------------------------" >> $log_location

$wu = new-object -com “Microsoft.Update.Searcher”
$totalupdates = $wu.GetTotalHistoryCount()

if($DEBUG) { echo "Total number of updates $($totalupdates)"} 
echo "Total number of updates $($totalupdates)" >> $log_location

$all = $wu.QueryHistory(0,$totalupdates)

#Reset temporary variable
$i=0
foreach ($kb_update in $KB)
{ 
    foreach ($update in $all)
    {
        $string = $update.title
        if ($string | Select-String -Pattern "$kb_update")
        {
            if($DEBUG) { echo "$($i).$($kb_update) is sucessfully installed"}
            echo "$($i).$($kb_update) is sucessfully installed" >> $log_location
            $KB_res += 1
            break
        }     
    }
    if($KB_res[$i] -lt 0)
    {
        if($DEBUG) { echo "$($i).$($kb_update) is not installed"}
        echo "$($i).$($kb_update) is not installed" >> $log_location
        $KB_res += 0
        $exit_status = $exit_status + 1
    }
    $i = $i + 1
}

if($DEBUG) { echo "Exiting exit_status_2=$($exit_status)"}
echo "Exiting exit_status_2=$($exit_status)" >> $log_location

if($DEBUG) {echo "*********************************"}
if($DEBUG) {echo "               END               "}
if($DEBUG) {echo "*********************************"}
echo "*********************************" >> $log_location
echo "               END               " >> $log_location
echo "*********************************" >> $log_location

exit $exit_status    