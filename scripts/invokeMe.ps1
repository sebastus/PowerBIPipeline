$dbName = "aas_Divin_c4b320a4-8d01-4544-89f8-ef85cd4fe4f6"
$svrName = "asazure://eastus.asazure.windows.net/pbissasserver04"

$aasAdminLogin = "greg@golivewaad.onmicrosoft.com"
$aasAdminPassword = "S7perSecr3t!"
$secpasswd = ConvertTo-SecureString $aasAdminPassword -AsPlainText -Force
$aasAdminCreds = New-Object System.Management.Automation.PSCredential($aasAdminLogin, $secpasswd)

Invoke-ProcessASDatabase -DatabaseName $dbName -RefreshType "Full" -Server $svrName -Credential $aasAdminCreds
