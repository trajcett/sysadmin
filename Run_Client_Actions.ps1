#*****************************************************************************#
# Author: NST                                                                 #
# Created Date: 06.04.2022                                                    #
# Description:																  #															
# Script executes all sccm cleint actions locally, or to a remote machine     #
#*****************************************************************************#

$input=0  # Input method   
$status = 0 # Exit status code 
$exit_message = ""

function check_usage 
{
    echo "Usage:"
    echo ".\Run_Client_Actions.ps1                       - Executes locally"
    echo ".\Run_Client_Actions.ps1 -h"    
    echo ".\Run_Client_Actions.ps1 -l List.txt           - Executes on list of devices"
    echo ".\Run_Client_Actions.ps1 DEVICE1 DEVICE2 ...   - Executes on the Devices provided"
}

if ($args.Count -lt 1)
{
    $input = 1
    $devices = $env:COMPUTERNAME

} elseif ($args[0] -eq '-h')
{
    check_usage
    exit

} elseif ($args[0] -eq '-l')
{
    if ($args.Count -lt 2)
    {
        echo ""
        echo "---->Provide the list of devices<---- `n"
        check_usage
        exit
    }

    $devices = Get-Content $args[1]

    #Set input metod to be executed
    $input = 2

}else
{
    $input = 3
}


$client_actions = @{

    'Machine_Policy_Retrieval_and_Evaluation_Cycle'   = '{00000000-0000-0000-0000-000000000021}'; 
    'Machine_Policy_Evaluation_Cycle'                 = '{00000000-0000-0000-0000-000000000022}'; 
    'Discovery_Data_Collection_Cycle'                 = '{00000000-0000-0000-0000-000000000003}'; 
    'Software_Inventory_Cycle'                        = '{00000000-0000-0000-0000-000000000002}';
    'Hardware_Inventory_Cycle'                        = '{00000000-0000-0000-0000-000000000001}';
    'Software_Updates_Scan_Cycle'                     = '{00000000-0000-0000-0000-000000000113}';
    'Software_Updates_Deployment_Evaluation_Cycle'    = '{00000000-0000-0000-0000-000000000114}';
    'Software_Metering_Usage_Report_Cycle'            = '{00000000-0000-0000-0000-000000000031}'; 
    'App_Deployment_Evaluation_Cycle'                 = '{00000000-0000-0000-0000-000000000121}'; 
    'User_Policy_Retrieval_and_Evaluation_Cycle'      = '{00000000-0000-0000-0000-000000000026}'; 
    'User_Policy_Evaluation_Cycle'                    = '{00000000-0000-0000-0000-000000000027}'; 
    'Windows_Installer_Source_List_Update_Cycle'      = '{00000000-0000-0000-0000-000000000032}';   
    'File_Collection_Cycle'                           = '{00000000-0000-0000-0000-000000000010}'; 

}

switch($input)
{
    1{
        echo "#----------------------#"
        echo "# $($devices)"
        echo "#----------------------#"

        foreach ( $action in $client_actions.GetEnumerator())
        {
            Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "$($action.Value)" 2>&1 | out-null
            $status = $?
            if ($status -eq "True")
            {
                $exit_message = "Success"
            }else
            {
                $exit_message = "Failed"
            }
            Write-Host "$($devices)-----> $($action.Name): $($action.Value)........ $($exit_message)"
        }

        break
     }

    2{
        foreach ($dev in $devices)
        {
            echo "#----------------------#"
            echo "# $($dev)"
            echo "#----------------------#"

                foreach ( $action in $client_actions.GetEnumerator())
                {
                    Invoke-WMIMethod -ComputerName $dev -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "$($action.Value)" 2>&1 | out-null
                    $status = $?
                    if ($status -eq "True")
                    {
                        $exit_message = "Success"
                    }else
                    {
                        $exit_message = "Failed"
                    }
                    Write-Host "$($devices)-----> $($action.Name): $($action.Value)........ $($exit_message)"
                }

        } 
        break
     }

    3{
        foreach ($dev in $args)
        {
            echo "#----------------------#"
            echo "# $($dev)"
            echo "#----------------------#"

                foreach ( $action in $client_actions.GetEnumerator())
                {
                    Invoke-WMIMethod -ComputerName $dev -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "$($action.Value)" 2>&1 | out-null
                    $status = $?
                    if ($status -eq "True")
                    {
                        $exit_message = "Success"
                    }else
                    {
                        $exit_message = "Failed"
                    }
                    Write-Host "$($devices)-----> $($action.Name): $($action.Value)........ $($exit_message)"
                }

        }
        break
     }
}