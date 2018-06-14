# common variables

# $index is appended to those names that must be globally unique. 
$index = "06" 

# a resource group to hold all resources. If you already have one, put the name here and 
# fix up InitializeResources.ps1 so it doesn't try to make a new rg.
$rgName = "pbiRg" + $index

# locations of the various components
$rgLocation = "EastUS"
# at the moment, this must be the same as the pbi tenant region
$pbiLocation = "EastUS"
# azure analysis service. this is where your pbi users will connect.
$aasLocation = "EastUS"
# sql server and azure data factory
$sqlLocation = "EastUS"
# storage account
$storageLocation = "EastUS"

# the administrator account for power bi and azure analysis services server
$admin = "you@yourTenant.onmicrosoft.com"

# the root folder where you cloned the repo
$devFolder = "C:\PowerBIPipeline"

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
$sqlSvrLogin = "admin"
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

# azure vnet details. ssisIrVnetId is the full resource id of your vnet.
$ssisIrVnetId = "/subscriptions/42a49846-7f53-48f7-a3b8-3e6bce9602ae/resourceGroups/myVnetRg/providers/Microsoft.Network/virtualNetworks/myVnet"
$ssisIrSubnet = "one"

# pbi embedded capacity
$capName = "pbicapacity" + $index
$capSku = "A1"

# analysis services server
$ssasName = "pbissasserver" + $index
$ssasSku = "D1"

