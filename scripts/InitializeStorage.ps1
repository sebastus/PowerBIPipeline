# get common 
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\common.ps1"

# storage account
$storageAccount = New-AzureRmStorageAccount -Location $storageLocation -Name $storageAcctName -ResourceGroupName $rgName -SkuName Standard_LRS
$storageContext = $storageAccount.Context
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAcctName).Value[0]
New-AzureStorageContainer -Name $dbContainerName -Context $storageContext -Permission blob
New-AzureStorageContainer -Name $adfContainerName -Context $storageContext -Permission blob

# upload the data warehouse schema to blob storage
Set-AzureStorageBlobContent -File $dwBacpacFile `
  -Container $dbContainerName `
  -Blob $dwBacpacBlob `
  -Context $storageContext

# powershell file that processes analysis service model
Set-AzureStorageBlobContent -File $adfProcessASDatabasePs1File `
  -Container $adfContainerName `
  -Blob $adfProcessASDatabasePs1Blob `
  -Context $storageContext `
  -Force

# cmd file that installs the powershell file
Set-AzureStorageBlobContent -File $adfMainCmdFile `
  -Container $adfContainerName `
  -Blob $adfMainCmdBlob `
  -Context $storageContext `
  -Force
