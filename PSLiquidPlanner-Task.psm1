<#
.SYNOPSIS
    Returns tasks from the connected Liquid Planner URL (optionally based on a filter)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Filter
    Parameter to specify filter to use in the query. Optional Parameter.
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
        $TaskURL = $TaskURL + $Filter
    }
    $Header = @{
        Authorization = "Bearer $Global:LiquidPlannerToken"
        Accept = "*/*"
    }
    $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    return $Result
}

<#
.SYNOPSIS
    Creates new task in the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Name
    Parameter to set the name of the new Liquid Planner task. Mandatory Parameter.
.PARAMETER Description
    Parameter to set the description of the new Liquid Planner task. Mandatory Parameter.
.EXAMPLE
    Creates a new task with the name Testing and a description saying Just a test
        New-LiquidPlannerTask -Name 'Testing' -Description 'Just a test'
#>
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