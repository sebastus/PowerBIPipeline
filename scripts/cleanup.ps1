$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\variables.ps1"

$rgName

Remove-AzureRmResourceGroup -name $rgName -force -asjob
