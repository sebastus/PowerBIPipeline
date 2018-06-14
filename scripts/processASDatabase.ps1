Param(
    [String]$aasAdminPassword,
    [string]$dbName,
    [string]$svrName,
    [string]$aasAdminLogin
)

$secpasswd = ConvertTo-SecureString $aasAdminPassword -AsPlainText -Force
$aasAdminCreds = New-Object System.Management.Automation.PSCredential($aasAdminLogin, $secpasswd)

Invoke-ProcessASDatabase -DatabaseName $dbName -RefreshType "Full" -Server $svrName -Credential $aasAdminCreds
