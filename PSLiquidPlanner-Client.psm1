<#
.SYNOPSIS
    Returns clients from the connected Liquid Planner URL (optionally based on a name)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Name
    Parameter to specify the name to search for. Operator is a contains condition. Optional Parameter.
.EXAMPLE
    Return clients that contains the name Client ABC
        Get-LiquidPlannerClient -Name 'Client ABC'
.EXAMPLE
    Return all clients
        Get-LiquidPlannerClient
#>
function Get-LiquidPlannerClient {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Name
    )
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/clients/'
    if ($Name) {
        $TaskURL = $TaskURL + '?filter[]=name%20contains%20' + $Name
    }
    $Header = @{
        Authorization = "Bearer $Global:LiquidPlannerToken"
        Accept = "*/*"
    }
    $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    return $Result
}