$ResourceGroupName = 'DockerTraining'
$ResourceGroupLocation = 'northeurope'
$TemplateFile = 'DockerOnUbuntuServer.json'
$secure_string_pwd = convertto-securestring "P@ssw0rd!" -asplaintext -force
$StorageAccountName = 'dockertraining2016'

# Check if resource group already exists
$ResourceGroupCount = Get-AzureRmResourceGroup | Where { $_.ResourceGroupName -match $ResourceGroupName } | Measure | Select Count
if ($ResourceGroupCount.Count -eq 0) {
    # Resource group does not yet exist, create it
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop 

    # Create a single storage account that will be used for all VHDs
    New-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName -Type Standard_LRS `
        -Location $ResourceGroupLocation -Verbose
}

# Trigger deployment
New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateFile $TemplateFile `
                                   -adminUsername 'training' -adminPassword $secure_string_pwd -dnsNameForPublicIP $ResourceGroupName.ToLower() `
                                   -ubuntuOSVersion '15.10' -storageAccountName $StorageAccountName `
                                   -Force -Verbose

# Just some useful other commands:
# Get-AzureRmVMImageSku -Location 'northeurope' -Offer 'UbuntuServer' -PublisherName 'Canonical'
# Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force -Verbose
