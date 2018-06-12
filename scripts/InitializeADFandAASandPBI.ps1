# get common 
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\common.ps1"

# storage account
$storageAccount = Get-AzureRmStorageAccount -Name $storageAcctName -ResourceGroupName $rgName
$storageContext = $storageAccount.Context

# sas for ADF container - good for 1 year.
$expiryDatetime = (Get-Date).AddYears(1).ToString("yyyy-MM-ddThh:mm:ssZ")
$sas = New-AzureStorageContainerSASToken -Name $adfContainerName -Context $storageContext -Permission rlw -ExpiryTime $expiryDatetime
$adfContainerSasUri = $adfContainerSasUriBase + $sas

# create the ADF
Set-AzureRmDataFactoryV2 -ResourceGroupName $rgName -Location $sqlLocation -Name $adfName

# create the SSIS IR
Set-AzureRmDataFactoryV2IntegrationRuntime  -ResourceGroupName $rgName `
    -DataFactoryName $adfName `
    -Name $ssisName `
    -Type Managed `
    -CatalogServerEndpoint $sqlSvrEndpoint `
    -CatalogAdminCredential $sqlSvrCreds `
    -CatalogPricingTier $sqlSvrTier `
    -Description $ssisDesc `
    -Edition $ssisEdition `
    -Location $sqlLocation `
    -NodeSize $ssisNodeSize `
    -NodeCount $ssisNodeCount `
    -MaxParallelExecutionsPerNode $ssisMaxExecPerNode `
    -SetupScriptContainerSasUri $adfContainerSasUri `
    -VNetId $ssisIrVnetId `
    -Subnet $ssisirSubnet
    

# ssas
New-AzureRmAnalysisServicesServer -resourceGroupName $rgName `
    -location $aasLocation `
    -name $ssasName `
    -sku $ssasSku `
    -administrator $admin

# pbi
New-AzureRmPowerBIEmbeddedCapacity -resourceGroupName $rgName `
    -location $pbiLocation `
    -name $capName `
    -sku $capSku `
    -administrator $admin

