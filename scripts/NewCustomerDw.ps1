# import data warehouse schema for a new customer
param (
    [Parameter(Mandatory=$true)]
    [string] $newDbName
)

# get common 
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\common.ps1"

# storage account
$storageAccount = Get-AzureRmStorageAccount -Name $storageAcctName -ResourceGroupName $rgName
$storageContext = $storageAccount.Context
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAcctName).Value[0]

$importRequest = New-AzureRmSqlDatabaseImport -ResourceGroupName $rgName `
   -ServerName $sqlSvrName `
   -DatabaseName $newDbName `
   -DatabaseMaxSizeBytes "262144000" `
   -StorageKeyType "StorageAccessKey" `
   -StorageKey $storageKey `
   -StorageUri $dwBacpacURI `
   -Edition "Standard" `
   -ServiceObjectiveName $sqlSvrTier `
   -AdministratorLogin $sqlSvrCreds.UserName `
   -AdministratorLoginPassword $sqlSvrCreds.Password

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