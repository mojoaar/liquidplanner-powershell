<#
.SYNOPSIS
    Returns members from the connected Liquid Planner URL (optionally based on a id)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Id
    Parameter to specify the id to search for. Operator is a contains condition. Optional Parameter.
.EXAMPLE
    Get-LiquidPlannerMember -Id '699656'
    Return the member with the id 699656
#>
function Get-LiquidPlannerMember {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Id
    )
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $MemberURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/members/'
    if ($Id) {
        $MemberURL = $MemberURL + $Id
    }
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $MemberURL -ContentType "application/json" -Headers $Header
    } else {
        $Result = Invoke-RestMethod -Method Get -Uri $MemberURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials
    }
    return $Result
}