$dbName = "aas_Divin_f72fe147-1e82-4bdd-9d7b-2e132d906b9d"
$svrName = "asazure://eastus.asazure.windows.net/mppssasserver03"

$aasAdminLogin = "greg@golivewaad.onmicrosoft.com"
$aasAdminPassword = "S7perSecr3t!"
$secpasswd = ConvertTo-SecureString $aasAdminPassword -AsPlainText -Force
$aasAdminCreds = New-Object System.Management.Automation.PSCredential($aasAdminLogin, $secpasswd)

Invoke-ProcessASDatabase -DatabaseName $dbName -RefreshType "Full" -Server $svrName -Credential $aasAdminCreds
