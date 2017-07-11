<#
.SYNOPSIS
    Returns projects from the connected Liquid Planner URL (optionally based on a filter)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Filter
    Parameter to specify filter to use in the query. Optional Parameter.
.EXAMPLE
    Get-LiquidPlannerProject -Filter '?filter[]=id=39235958'
    Return the project whose number is exactly 39235958
.EXAMPLE
    Get-LiquidPlannerProject -Filter '?filter[]=client_id=39602873'
    Return the projects where the client is 39602873
.EXAMPLE
    Get-LiquidPlannerProject -Filter '?filter[]=is_done%20is%20false'
    Return all projects that are not marked as done
.EXAMPLE
    Get-LiquidPlannerProject -ProjectId '36828051'
    Return the project that has id 36828051
#>
function Get-LiquidPlannerProject {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Filter,
        [Parameter(Mandatory=$false)]
        [int] $ProjectId
    )
    if ((Test-LiquidPlannerAuthIsSet) -eq $false) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $ProjectURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/projects/'
    if ($Filter) {
        $ProjectURL = $ProjectURL + $Filter
    } elseif ($ProjectId) {
        $ProjectURL = $ProjectURL + '?filter[]=project_id=' + $ProjectId
    }
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $ProjectURL -ContentType "application/json" -Headers $Header
    } else {
        $Result = Invoke-RestMethod -Method Get -Uri $ProjectURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials
    }
    return $Result
}