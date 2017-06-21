<#
.SYNOPSIS
   Returns tasks from the connected Liquid Planner URL (optionally based on a filter)
.NOTES
   You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.EXAMPLE
    Return the task whose number is exactly 39235958
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
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
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

function New-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [string] $Description
    )
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    $Header = @{
        Authorization = "Bearer $Global:LiquidPlannerToken"
        Accept = "*/*"
    }
    $Body = @{
    task = @{
        name = "$Name"
        description = "$Description"
    }
    }
    $Body = ConvertTo-Json -InputObject $Body -Depth 10
    $Result = Invoke-RestMethod -Method Post -uri $TaskURL -ContentType "application/json" -Headers $Header -Body $Body
    return $Result
}