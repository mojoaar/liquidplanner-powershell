function Get-LiquidPlannerWorkspace {
    $WorkspaceURL = $Global:LiquidPlannerRESTURL + '/workspaces/'
    if ($Global:LiquidPlannerToken) {
        $Header = @{
            Authorization = "Bearer $Global:LiquidPlannerToken"
            Accept = "*/*"
        }
        $Result = Invoke-RestMethod -Method Get -Uri $WorkspaceURL -ContentType "application/json" -Headers $Header
    }
    return $Result
}