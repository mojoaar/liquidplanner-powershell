# PSLiquidPlanner
This PowerShell module provides a series of cmdlets for interacting with the [Liquid Planner API](https://www.liquidplanner.com/support/articles/developer-tools/). Invoke-RestMethod is used for all API calls.

## Requirements
Requires PowerShell 3.0 or above (this is when `Invoke-RestMethod` was introduced).

## Usage
Download the [latest release](https://github.com/mgjohansen/liquidplanner-powershell/releases/latest) and  extract the .psm1 and .psd1 files to your PowerShell profile directory (i.e. the `Modules` directory under wherever `$profile` points to in your PS console) and run:
`Import-Module PSLiquidPlanner`
Once you've done this, all the cmdlets will be at your disposal, you can see a full list using `Get-Command -Module PSLiquidPlanner`. Remember to run Set-LiquidPlannerAuthToken & Set-LiquidPlannerWorkspace before beginning to work in your environment.

## Cmdlets
* Get-LiquidPlannerClient
* Get-LiquidPlannerMember
* Get-LiquidPlannerTask
* Get-LiquidPlannerWorkspace
* New-LiquidPlannerTask
* Remove-LiquidPlannerAuth
* Set-LiquidPlannerAuth
* Set-LiquidPlannerAuthToken
* Set-LiquidPlannerWorkspace
* Test-LiquidPlannerAuthIsSet

## Author
Author: Morten G. Johansen (<morten@glerupjohansen.dk>)