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
    Get-LiquidPlannerClient -Name 'Client ABC'
    Return clients that contains the name Client ABC
.EXAMPLE
    Get-LiquidPlannerClient -Filter '?filter[]=name%20contains%20Microsoft'
    Return clients that contains the name Microsoft
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