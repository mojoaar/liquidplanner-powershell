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

<#
.SYNOPSIS
    Creates new project in the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER Name
    Parameter to set the name of the new Liquid Planner project. Mandatory Parameter.
.PARAMETER Description
    Parameter to set the description of the new Liquid Planner project. Mandatory Parameter.
.PARAMETER PersonId
    Parameter to set assignment of the new Liquid Planner project. Optional Parameter.
.PARAMETER Reference
    Parameter to set the external_reference field of the new Liquid Planner project. Optional Parameter.
.PARAMETER ClientId
    Parameter to set the client_id field of the new Liquid Planner project. Optional Parameter.
.PARAMETER ParentId
    Parameter to set the parent_id field of the new Liquid Planner project. Optional Parameter.
.EXAMPLE
    New-LiquidPlannerProject -Name 'Testing' -Description 'Just a test'
    Creates a new project with the name Testing and a description saying Just a test, will set the assignment to unassigned
.EXAMPLE
    New-LiquidPlannerProject -Name 'Testing' -Description 'Just a test' -PersonId '0'
    Creates a new project with the name Testing and a description saying Just a test, will assign to Person Id 0 (unassigned)
.EXAMPLE
    New-LiquidPlannerProject -Name 'Testing' -Description 'Just a test' -Reference 'Ref Test'
    Creates a new project with the name Testing and a description saying Just a test, will set the reference to Ref Test
.EXAMPLE
    New-LiquidPlannerProject -Name 'Testing' -Description 'Just a test' -Reference 'Ref Test' -PersonId '123' -ClienId '456' -ParentId '789'
    Creates a new project with the name Testing, a description saying Just a test, set's the reference to Ref Test, assign to person 123, link to customer 456 and put's it under parent 789
#>
function New-LiquidPlannerProject {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [string] $Description,
        [Parameter(Mandatory=$false)]
        [string] $PersonId,
        [Parameter(Mandatory=$false)]
        [string] $Reference,
        [Parameter(Mandatory=$false)]
        [string] $ClientId,
        [Parameter(Mandatory=$false)]
        [string] $ParentId
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
    if ($PersonId) {
    $Body = @{
        project = @{
            name = "$Name"
            description = "$Description"
            external_reference = "$Reference"
            client_id = "$ClientId"
            parent_id = "$ParentId"
                assignments = @(@{
                    person_id = "$PersonId"
                })
        }
    }
    } else {
    $Body = @{
        project = @{
            name = "$Name"
            description = "$Description"
            external_reference = "$Reference"
            client_id = "$ClientId"
            parent_id = "$ParentId"
                assignments = @(@{
                    person_id = "0"
                })
        }
    }
    }
    $Body = ConvertTo-Json -InputObject $Body -Depth 10
    $Body = [System.Text.Encoding]::UTf8.GetBytes($Body)
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Post -Uri $ProjectURL -ContentType "application/json" -Headers $Header -Body $Body
    } else {
        $Result = Invoke-RestMethod -Method Post -Uri $ProjectURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials -Body $Body
    }
    return $Result
}

<#
.SYNOPSIS
    Add a comment to an existing project in the connected Liquid Planner URL
.NOTES
    You must have invoked Set-LiquidPlannerAuth or Set-LiquidPlannerAuthToken prior to executing this cmdlet
.PARAMETER ProjectId
    Parameter to use for the Project Id of the Liquid Planner project. Mandatory Parameter.
.PARAMETER Comment
    Parameter for the comment to send to the Liquid Planner project. Mandatory Parameter.
.EXAMPLE
    Add-LiquidPlanerProjectComment -ProjectId '39393798' -Comment 'Project comment test'
    Will add a comment to project 39393798 saying Project comment test
#>
function Add-LiquidPlanerProjectComment {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $ProjectId,
        [Parameter(Mandatory=$true)]
        [string] $Comment
    )
    if ((Test-LiquidPlannerAuthIsSet) -eq $false) {
        'You need to set the Authorization with Set-LiquidPlannerAuthToken or Set-LiquidPlannerAuth'
        break
    }
    if (-not $Global:LiquidPlannerWorkspace) {
        'You need to set the Workspace Id with Set-LiquidPlannerWorkspace'
        break
    }
    $ProjectCommentURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/projects/' + $ProjectId + '/comments'
    $Body = @{
        comment = @{
            comment = "$Comment"
        }
    }
    $Body = ConvertTo-Json -InputObject $Body -Depth 10
    $Body = [System.Text.Encoding]::UTf8.GetBytes($Body)
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Post -Uri $ProjectCommentURL -ContentType "application/json" -Headers $Header -Body $Body
    } else {
        $Result = Invoke-RestMethod -Method Post -Uri $ProjectCommentURL -ContentType "application/json" -Credential $Global:LiquidPlannerCredentials -Body $Body
    }
    return $Result
}