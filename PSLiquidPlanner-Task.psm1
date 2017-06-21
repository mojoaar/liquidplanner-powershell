<#
.Synopsis
   Returns tasks from the connected Liquid Planner URL (optionally based on a filter)
.NOTES
   You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.EXAMPLE
    Return the incident whose number is exactly INC0010683
        Get-LiquidPlannerTask -Filter '?filter[]=id=39235958'
.EXAMPLE
    Return all tasks that are not marked as done
        Get-LiquidPlannerTask -Filter '?filter[]=is_done%20is%20false'
#>

function Get-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Filter
    )
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    if ($Filter) {
        # Example use of filter: '?filter[]=is_done%20is%20false'
        $TaskURL = $TaskURL + $Filter
    }
    $Header = @{
        Authorization = "Bearer $Global:LiquidPlannerToken"
        Accept = "*/*"
    }
    $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    return $Result
}