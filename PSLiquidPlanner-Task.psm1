<#
.SYNOPSIS
    Returns tasks from the connected Liquid Planner URL (optionally based on a filter)
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Filter
    Parameter to specify filter to use in the query. Optional Parameter.
.EXAMPLE
    Get-LiquidPlannerTask -Filter '?filter[]=id=39235958'
    Return the task whose number is exactly 39235958
.EXAMPLE
    Get-LiquidPlannerTask -Filter '?filter[]=is_done%20is%20false'
    Return all tasks that are not marked as done
.EXAMPLE
    Get-LiquidPlannerTask -ProjectId '36828051'
    Return all tasks that belongs to project 36828051
#>
function Get-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$false)]
        [string] $Filter,
        [Parameter(Mandatory=$false)]
        [int] $ProjectId
    )
    if (-not $Global:LiquidPlannerCredentials -or $Global:LiquidPlannerToken) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    if ($Filter) {
        $TaskURL = $TaskURL + $Filter
    } elseif ($ProjectId) {
        $TaskURL = $TaskURL + '?filter[]=project_id=' + $ProjectId
    }
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    } else {
        $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials
    }
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
    New-LiquidPlannerTask -Name 'Testing' -Description 'Just a test'
    Creates a new task with the name Testing and a description saying Just a test
#>
function New-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [string] $Description
    )
    if (-not $Global:LiquidPlannerCredentials -or $Global:LiquidPlannerToken) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    $Body = @{
        task = @{
            name = "$Name"
            description = "$Description"
        }
    }
    $Body = ConvertTo-Json -InputObject $Body -Depth 10
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Post -Uri $TaskURL -ContentType "application/json" -Headers $Header -Body $Body
    } else {
        $Result = Invoke-RestMethod -Method Post -Uri $TaskURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials -Body $Body
    }
    return $Result
}