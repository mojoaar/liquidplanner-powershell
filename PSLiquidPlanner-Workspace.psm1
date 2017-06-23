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
    if (-not $Global:LiquidPlannerCredentials -or $Global:LiquidPlannerToken) {
        'You need to set the Authorization before running Get-LiquidPlannerWorkspace'
        break
    }
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Headers $Header
    } else {
        $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials
    }
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
    Set-LiquidPlannerWorkspace -Id '123456'
    Will set the workspace id to 123456
#>
function Set-LiquidPlannerWorkspace {
    Param (
        [Parameter(Mandatory=$true)]
        [int] $Id
    )
    $Global:LiquidPlannerWorkspace = $Id
    return $true;
}