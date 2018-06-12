# common variables

# $index is appended to those names that must be globally unique. 
$index = "06" 

$rgName = "pbiRg" + $index
$pbiLocation = "EastUS"
$aasLocation = "EastUS"
$sqlLocation = "EastUS"
$rgLocation = "EastUS"
$storageLocation = "EastUS"
$admin = "greg@golivewaad.onmicrosoft.com"
$devFolder = "C:\Users\Divin\OneDrive - Microsoft\VSProjects\pbiPipeline"

# storage & bacpac
$storageAcctName = "pbipipelinestorage" + $index
$dbContainerName = "database"
$adfContainerName = "processmodelscripts"
$adfContainerSasUriBase = "https://$storageAcctName.blob.core.windows.net/$adfContainerName/"

# data warehouse
$dwBacpacFile = "$devFolder\db\dwSchema.bacpac"
$dwBacpacBlob = "dwSchema.bacpac"
$dwBacpacURI = "http://$storageAcctName.blob.core.windows.net/$dbContainerName/$dwBacpacBlob"

# azure sql db
$sqlSvrLogin = "greg"
$sqlSvrName = "pbisqlbox" + $index
$sqlSvrTier = "S0"
$sqlSvrEndpoint = $sqlSvrName + ".database.windows.net"
if ($sqlSvrCreds -eq $null) {
    $sqlSvrCreds = Get-Credential -UserName $sqlSvrLogin -Message "SQL Server Credentials"
}

# adf files
$adfMainCmdFile = "$devFolder\scripts\main.cmd"
$adfMainCmdBlob = "main.cmd"
$adfProcessASDatabasePs1File = "$devFolder\scripts\ProcessASDatabase.ps1"
$adfProcessASDatabasePs1Blob = "processasdatabase.ps1"

# adf infra
$adfName = "pbiADF" + $index
$ssisName = "pbiSSIS" + $index
$ssisDesc = "pbi SSIS cluster"
$ssisEdition = "Standard"
$ssisNodeSize = "Standard_D3_v2"
$ssisNodeCount = 2
$ssisMaxExecPerNode = 2
$ssisIrVnetId = "/subscriptions/42a49846-7f53-48f7-a3b8-3e6bce9602ae/resourceGroups/myVnetRg/providers/Microsoft.Network/virtualNetworks/myVnet"
$ssisIrSubnet = "one"

# pbi embedded capacity
$capName = "pbicapacity" + $index
$capSku = "A1"

# analysis services server
$ssasName = "pbissasserver" + $index
$ssasSku = "D1"

