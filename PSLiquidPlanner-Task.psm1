function Get-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$false)]
        [int] $Id
    )
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    if ($Id) {
        $TaskURL = $TaskURL + $Id
    }
    if ($Global:LiquidPlannerWorkspace) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    }
    return $Result
}