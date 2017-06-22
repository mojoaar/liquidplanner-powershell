<#
.SYNOPSIS
    Test if auth is set in the current session
.EXAMPLE
    Will check if auth is set either from credentials or a token
        Test-LiquidPlannerAuthIsSet
#>
function Test-LiquidPlannerAuthIsSet {
    if ($Global:LiquidPlannerCredentials -or $Global:LiquidPlannerToken) {
        return $true;
    } else {
        return $false;
    }
}

<#
.SYNOPSIS
    Test if a workspace id is set in the current session
.EXAMPLE
    Will check if a workspace id is set
        Test-LiquidPlannerWorkspaceIdIsSet
#>
function Test-LiquidPlannerWorkspaceIdIsSet {
    if ($Global:LiquidPlannerWorkspace) {
        return $true;
    } else {
        return $false;
    }
}

<#
.SYNOPSIS
    Set's the auth to your Liquid Planner URL using credentials
.PARAMETER Creadentials
    Parameter to specify the credentials to use. Mandatory Parameter.
.EXAMPLE
    Set the credentials to user@company.com
        Set-LiquidPlannerAuth -Credentials 'user@company.com'
#>
function Set-LiquidPlannerAuth {
    param(
        [parameter(mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credentials
    )
    $Global:LiquidPlannerRESTURL = 'https://app.liquidplanner.com/api'
    $Global:LiquidPlannerCredentials = $Credentials
    return $true;
}

<#
.SYNOPSIS
    Set's the auth to your Liquid Planner URL using a token
.NOTES
    Tokens can be created under Settings -> My API Tokens in Liquid Planner
.PARAMETER Token
    Parameter to specify filter to use in the query. Optional Parameter.
.EXAMPLE
    Set's the auth token to 12a3bc4d-5678-9e0f-8c92-8affa74dd371
        Set-LiquidPlannerAuthToken -Token '12a3bc4d-5678-9e0f-8c92-8affa74dd371'
#>
function Set-LiquidPlannerAuthToken {
    param(
        [parameter(mandatory=$true)]
        [string]$Token
    )
    $Global:LiquidPlannerRESTURL = 'https://app.liquidplanner.com/api'
    $Global:LiquidPlannerToken = $Token
    return $true;
}

<#
.SYNOPSIS
    Removes all Liquid Planner related variables
.EXAMPLE
    Will clean your environment and remove all Liquid Planner Global variables
        Remove-LiquidPlannerAuth
#>
function Remove-LiquidPlannerAuth {

    Remove-Variable -Name LiquidPlannerRESTURL -Scope Global
    Remove-Variable -Name LiquidPlannerCredentials -Scope Global
    Remove-Variable -Name LiquidPlannerToken -Scope Global
    Remove-Variable -Name LiquidPlannerWorkspace -Scope Global
    return $true;
}