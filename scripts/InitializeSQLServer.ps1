# get common 
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\common.ps1"

# get my IP
$response = Invoke-WebRequest -uri "ipinfo.io/ip"
$externalIP = $response.Content
$firstDot = $externalIP.indexOf(".")
$secondDot = $externalIP.indexOf(".",$firstDot+1)
$startingIP = $externalIP.substring(0,$secondDot+1) + "0.0"
$endingIP = $externalIP.substring(0,$secondDot+1) + "255.255"

# sql server
New-AzureRmSqlServer -resourceGroupName $rgName `
    -location $sqllocation `
    -serverName $sqlSvrName `
    -SqlAdministratorCredentials $sqlSvrCreds

New-AzureRmSqlServerFirewallRule -ResourceGroupName $rgName `
    -AllowAllAzureIPs `
    -ServerName $sqlSvrName

New-AzureRmSqlServerFirewallRule -ResourceGroupName $rgName `
    -ServerName $sqlSvrName `
    -FirewallRuleName "devOpsClient" `
    -StartIpAddress $startingIP `
    -EndIpAddress $endingIP

