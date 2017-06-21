function Get-LiquidPlannerTask {
    Param (
        [Parameter(Mandatory=$false)]
        [int] $Id,
        [Parameter(Mandatory=$false)]
        [string] $Filter
    )
    $TaskURL = $Global:LiquidPlannerRESTURL + '/workspaces/' + $Global:LiquidPlannerWorkspace + '/tasks/'
    if ($Id) {
        $TaskURL = $TaskURL + $Id
    } elseif ($Id -and $Filter) {
        $TaskURL = $TaskURL + $Id + $Filter
    }

    $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    return $Result
}