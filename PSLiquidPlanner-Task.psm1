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
    } elseif ($Filter) {
        # Example use of filter: '?filter[]=is_done%20is%20false'
        $TaskURL = $TaskURL + $Filter
    } elseif ($Id -and $Filter) {
        $TaskURL = $TaskURL + $Id + $Filter
    }

    $Result = Invoke-RestMethod -Method Get -Uri $TaskURL -ContentType "application/json" -Headers $Header
    return $Result
}