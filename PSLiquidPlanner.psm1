function Test-LiquidPlannerAuthIsSet{
    if($Global:LiquidPlannerCredentials){
        return $true;
    }else{
        return $false;
    }
}

function Set-LiquidPlannerAuth{
    param(
        [parameter(mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credentials
    )
    $Global:LiquidPlannerRESTURL = 'https://app.liquidplanner.com/api'
    $Global:LiquidPlannerCredentials = $Credentials
    return $true;
}

function Set-LiquidPlannerAuthToken{
    param(
        [parameter(mandatory=$true)]
        [string]$Token
    )
    $Global:LiquidPlannerRESTURL = 'https://app.liquidplanner.com/api'
    $Global:LiquidPlannerToken = $Token
    return $true;
}

function Remove-LiquidPlannerAuth{

    Remove-Variable -Name LiquidPlannerRESTURL -Scope Global
    Remove-Variable -Name LiquidPlannerCredentials -Scope Global

    return $true;
}