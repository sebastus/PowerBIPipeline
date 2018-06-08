$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\variables.ps1"

Write-Output $rgName

