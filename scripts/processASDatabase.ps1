$dbName = "TabularOnAzure_Divin_7c79f071-d46d-4ef2-bf6d-ad88e2b25762"
$svrName = "asazure://eastus.asazure.windows.net/mppssasserver02"

$sqlSvrLogin = "greg@golivewaad.onmicrosoft.com"
$sqlSvrPassword = "S7perSecr3t!"
$secpasswd = ConvertTo-SecureString $sqlSvrPassword -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($sqlSvrLogin, $secpasswd)
$creds = Get-Credential -userName $sqlSvrLogin -Message "sql server login"

Invoke-ProcessASDatabase -DatabaseName $dbName -RefreshType "Full" -Server $svrName -credential $creds



