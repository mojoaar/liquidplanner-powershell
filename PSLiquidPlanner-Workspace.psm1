<#
.SYNOPSIS
    Get the workspaces from the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.EXAMPLE
    Get-LiquidPlannerWorkspace
    Will get all the workspaces of the connected Liquid Planner URL
#>
function Get-LiquidPlannerWorkspace {
    $WorkspaceURL = $Global:LiquidPlannerRESTURL + '/workspaces/'
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Headers $Header
    } else {
        $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Headers $Header -Credential $Global:LiquidPlannerCredentials
    }
    $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Headers $Header
    return $Result
}

<#
.SYNOPSIS
    Set the workspaces from the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Id
    Parameter to specify workspace Id to work in. Mandatory Parameter.
.EXAMPLE
    Will set the workspace id to 123456
        Set-LiquidPlannerWorkspace -Id '123456'
#>
function Set-LiquidPlannerWorkspace {
    Param (
        [Parameter(Mandatory=$true)]
        [int] $Id
    )
    $Global:LiquidPlannerWorkspace = $Id
    return $true;
}