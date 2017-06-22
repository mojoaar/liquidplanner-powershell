# PSLiquidPlanner
This PowerShell module provides a series of cmdlets for interacting with the [Liquid Planner API](https://www.liquidplanner.com/support/articles/developer-tools/). Invoke-RestMethod is used for all API calls.

## Requirements
Requires PowerShell 3.0 or above (this is when `Invoke-RestMethod` was introduced.)

## Cmdlets
* Get-LiquidPlannerClient
* Get-LiquidPlannerTask
* Get-LiquidPlannerWorkspace
* New-LiquidPlannerTask
* Remove-LiquidPlannerAuth
* Set-LiquidPlannerAuth
* Set-LiquidPlannerAuthToken
* Set-LiquidPlannerWorkspace
* Test-LiquidPlannerAuthIsSet

## Author
Author:: Morten G. Johansen (<morten@glerupjohansen.dk>)