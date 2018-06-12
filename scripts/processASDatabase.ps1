Param(
    [String]$aasAdminPassword,
    [string]$dbName,
    [string]$svrName,
    [string]$aasAdminLogin
)

# $dbName = "TabularProject1_Divin_453cf754-e5b2-4ddf-8b74-e2ecf361dab3"
# $svrName = "asazure://eastus.asazure.windows.net/pbissasserver07"
# $aasAdminLogin = "greg@golivewaad.onmicrosoft.com"
# $aasAdminPassword = Get-Content .\password.txt

$secpasswd = ConvertTo-SecureString $aasAdminPassword -AsPlainText -Force
$aasAdminCreds = New-Object System.Management.Automation.PSCredential($aasAdminLogin, $secpasswd)

Invoke-ProcessASDatabase -DatabaseName $dbName -RefreshType "Full" -Server $svrName -Credential $aasAdminCreds
