# basics
$index = "06"
$rgName = "pbiRg" + $index
$location = "EastUS"
$admin = "greg@golivewaad.onmicrosoft.com"
$devFolder = "C:\Users\Divin\OneDrive - Microsoft\VSProjects\pbiPipeline"

# storage & bacpac
$storageAcctName = "pbistoragetest" + $index
$containerName = "devops"
$containerSasUriBase = "https://$storageAcctName.blob.core.windows.net/$containerName/"

$dwBacpacFile = "$devFolder\db\dwAdventureWorks.bacpac"
$dwBacpacBlob = "dw.bacpac"
$dwBacpacURI = "http://$storageAcctName.blob.core.windows.net/$containerName/$dwBacpacBlob"

$adfMainCmdFile = "$devFolder\scripts\main.cmd"
$adfMainCmdBlob = "main.cmd"

$adfInvokeMePs1File = "$devFolder\scripts\invokeme.ps1"
$adfInvokeMePs1Blob = "invokeme.ps1"

# pbi embedded capacity
$capName = "pbicapacity" + $index
$capSku = "A1"

# analysis services server
$ssasName = "pbissasserver" + $index
$ssasSku = "D1"

# azure sql db
$sqlSvrLogin = "greg"
$sqlSvrPassword = "S7perSecr3t!"
$sqlSvrName = "pbisqlbox" + $index
$dbName = "dwCustomer1"
$sqlSvrTier = "S0"
$sqlSvrEndpoint = $sqlSvrName + ".database.windows.net"
$sqlSvrFirewallStartIP = "167.220.0.0"
$sqlSvrFirewallEndIP = "167.220.255.255"
$secpasswd = ConvertTo-SecureString $sqlSvrPassword -AsPlainText -Force
$sqlSvrCreds = New-Object System.Management.Automation.PSCredential($sqlSvrLogin, $secpasswd)

# azure data factory
$adfName = "pbiADF" + $index
$ssisName = "pbiSSIS" + $index
$ssisDesc = "pbi SSIS cluster"
$ssisEdition = "Standard"
$ssisNodeSize = "Standard_D3_v2"
$ssisNodeCount = 2
$ssisMaxExecPerNode = 2

