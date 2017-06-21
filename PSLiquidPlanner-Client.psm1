<#
.SYNOPSIS
    Returns clients from the connected Liquid Planner URL (optionally based on a name)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Name
    Parameter to specify the name to search for. Operator is a contains condition. Optional Parameter.
.PARAMETER Filter
    Parameter to specify filter to use in the query. Optional Parameter.
.EXAMPLE
    Return clients that contains the name Client ABC
        Get-LiquidPlannerClient -Name 'Client ABC'
.EXAMPLE
    Return clients that contains the name Microsoft
        Get-LiquidPlannerClient -Filter '?filter[]=name%20contains%20Microsoft'
#>
function Get-LiquidPlannerClient {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Name,
        [Parameter(Mandatory=$false)]
        [string] $Filter
    )
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $ClientURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/clients/'
    if ($Name) {
        $ClientURL = $ClientURL + '?filter[]=name%20contains%20' + $Name
    } elseif ($Filter) {
        $ClientURL = $ClientURL + $Filter
    }
    $Header = @{
        Authorization = "Bearer $Global:LiquidPlannerToken"
        Accept = "*/*"
    }
    $Result = Invoke-RestMethod -Method Get -Uri $ClientURL -ContentType "application/json" -Headers $Header
    return $Result
}