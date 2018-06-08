$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition 
. "$scriptPath\variables.ps1"

$sas = New-AzureStorageContainerSASToken -Name "devops" -Context $storageContext -Permission rlw
$containerSasUri = $containerSasUriBase + $sas

# powershell file that processes analysis service model
Set-AzureStorageBlobContent -File $adfInvokeMePs1File `
  -Container $containerName `
  -Blob $adfInvokeMePs1Blob `
  -Context $storageContext `
  -Force

# cmd file that installs the powershell file
Set-AzureStorageBlobContent -File $adfMainCmdFile `
  -Container $containerName `
  -Blob $adfMainCmdBlob `
  -Context $storageContext `
  -Force

# adf
$DataFactory = Set-AzureRmDataFactoryV2 -ResourceGroupName $rgName -Location $location -Name $adfName
Set-AzureRmDataFactoryV2IntegrationRuntime  -ResourceGroupName $rgName `
                                            -DataFactoryName $adfName `
                                            -Name $ssisName `
                                            -Type Managed `
                                            -CatalogServerEndpoint $sqlSvrEndpoint `
                                            -CatalogAdminCredential $sqlSvrCreds `
                                            -CatalogPricingTier $sqlSvrTier `
                                            -Description $ssisDesc `
                                            -Edition $ssisEdition `
                                            -Location $location `
                                            -NodeSize $ssisNodeSize `
                                            -NodeCount $ssisNodeCount `
                                            -MaxParallelExecutionsPerNode $ssisMaxExecPerNode `
                                            -SetupScriptContainerSasUri $containerSasUri


# start the SSIS IR
Start-AzureRmDataFactoryV2IntegrationRuntime -DataFactoryName $adfName `
                                            -Name $ssisName `
                                            -ResourceGroupName $rgName `
                                            -Force

# pbi
New-AzureRmPowerBIEmbeddedCapacity -resourceGroupName $rgName -location $location -name $capName -sku $capSku -administrator $admin

# ssas
New-AzureRmAnalysisServicesServer -resourceGroupName $rgName -location $location -name $ssasName -sku $ssasSku -administrator $admin

