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
    if ((Test-LiquidPlannerAuthIsSet) -eq $false) {
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
.PARAMETER PersonId
    Parameter to set assignment of the new Liquid Planner task. Optional Parameter.
.EXAMPLE
    New-LiquidPlannerTask -Name 'Testing' -Description 'Just a test'
    Creates a new task with the name Testing and a description saying Just a test, will set the assignment to unassigned
.EXAMPLE
    New-LiquidPlannerTask -Name 'Testing' -Description 'Just a test' -PersonId '0'
    Creates a new task with the name Testing and a description saying Just a test, will assign to Person Id 0 (unassigned)
#>
function New-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [string] $Description,
        [Parameter(Mandatory=$false)]
        [string] $PersonId
    )
    if ((Test-LiquidPlannerAuthIsSet) -eq $false) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    if ($PersonId) {
    $Body = @{
        task = @{
            name = "$Name"
            description = "$Description"
                assignments = @(@{
                    person_id = "$PersonId"
                })
        }
    }
    } else {
    $Body = @{
        task = @{
            name = "$Name"
            description = "$Description"
                assignments = @(@{
                    person_id = "0"
                })
        }
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

<#
.SYNOPSIS
    Add a link to an existing task in the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER TaskId
    Parameter to set the Task Id of the Liquid Planner task. Mandatory Parameter.
.PARAMETER Url
    Parameter to set Url of the destination link. Mandatory Parameter.
.PARAMETER Description
    Parameter to set Description of the link. Optional Parameter.
.EXAMPLE
    Add-LiquidPlannerTaskLink -TaskID '123456' -Url 'https://google.com'
    Adds the link https://google.com to the task 123456
.EXAMPLE
    Add-LiquidPlannerTaskLink -TaskID '123456' -Url 'https://google.com' -Description 'Google is awesome!'
    Adds the link https://google.com to the task 123456 and set's the Description to Google is awesome!
#>
function Add-LiquidPlannerTaskLink {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $TaskId,
        [Parameter(Mandatory=$true)]
        [string] $Url,
        [Parameter(Mandatory=$false)]
        [string] $Description
    )
    if ((Test-LiquidPlannerAuthIsSet) -eq $false) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $LinkURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/links/'
    $Body = @{
        link = @{
            item_id = "$TaskId"
            url = "$Url"
            description = "$Description"
        }
    }
    $Body = ConvertTo-Json -InputObject $Body -Depth 10
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Post -Uri $LinkURL -ContentType "application/json" -Headers $Header -Body $Body
    } else {
        $Result = Invoke-RestMethod -Method Post -Uri $LinkURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials -Body $Body
    }
    return $Result
}