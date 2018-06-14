<#
  Don't forget to:
  * Customize the values in common.ps1
  * Connect-AzureRmAccount
#>

# get common 
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\common.ps1"

# resource group
New-AzureRmResourceGroup -name $rgName -location $rgLocation

. "$scriptPath\InitializeStorage.ps1"
. "$scriptPath\InitializeSQLServer.ps1"
. "$scriptPath\InitializeADFandAASandPBI.ps1"
