# Connect-AzureRmAccount

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\variables.ps1"

# ##########################
# Creation of infrastructure assets
# ##########################

# resource group
New-AzureRmResourceGroup -name $rgName -location $location

# storage account
$storageAccount = New-AzureRmStorageAccount -Location $location -Name $storageAcctName -ResourceGroupName $rgName -SkuName Standard_LRS
$storageContext = $storageAccount.Context
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAcctName).Value[0]
New-AzureStorageContainer -Name $containerName -Context $storageContext -Permission blob

# upload the data warehouse schema to blob storage
Set-AzureStorageBlobContent -File $dwBacpacFile `
  -Container $containerName `
  -Blob $dwBacpacBlob `
  -Context $storageContext

# get my IP
$response = wget -uri "ipinfo.io/ip"
# $externalIP = (ConvertFrom-jSON -inputObject $response.content).ip
$externalIP = $response.Content
$firstDot = $externalIP.indexOf(".")
$secondDot = $externalIP.indexOf(".",$firstDot+1)
$startingIP = $externalIP.substring(0,$secondDot+1) + "0.0"
$endingIP = $externalIP.substring(0,$secondDot+1) + "255.255"

# sql server
New-AzureRmSqlServer -resourceGroupName $rgName -location $location -serverName $sqlSvrName -SqlAdministratorCredentials $sqlSvrCreds
New-AzureRmSqlServerFirewallRule -ResourceGroupName $rgName -AllowAllAzureIPs -ServerName $sqlSvrName
New-AzureRmSqlServerFirewallRule -ResourceGroupName $rgName -ServerName $sqlSvrName -FirewallRuleName "devOpsClient" -StartIpAddress $startingIP -EndIpAddress $endingIP

# install the schema as a customer data warehouse
$importRequest = New-AzureRmSqlDatabaseImport -ResourceGroupName $rgName `
   -ServerName $sqlSvrName `
   -DatabaseName $dbName `
   -DatabaseMaxSizeBytes "262144000" `
   -StorageKeyType "StorageAccessKey" `
   -StorageKey $storageKey `
   -StorageUri $dwBacpacURI `
   -Edition "Standard" `
   -ServiceObjectiveName $sqlSvrTier `
   -AdministratorLogin $sqlSvrLogin `
   -AdministratorLoginPassword (ConvertTo-SecureString $sqlSvrPassword -AsPlainText -Force)

$importStatus = Get-AzureRmSqlDatabaseImportExportStatus -OperationStatusLink $importRequest.OperationStatusLink
[Console]::Write("Importing")
while ($importStatus.Status -eq "InProgress")
{
    $importStatus = Get-AzureRmSqlDatabaseImportExportStatus -OperationStatusLink $importRequest.OperationStatusLink
    [Console]::Write(".")
    Start-Sleep -s 10
}
[Console]::WriteLine("")
$importStatus

