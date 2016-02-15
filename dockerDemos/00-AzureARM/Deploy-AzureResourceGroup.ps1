# Some paths...
# Note that this script needs PuTTY and openssl
$putty = "c:\Program Files (x86)\PuTTY"
$openssl = "c:\Program Files\OpenSSL-Win64\bin"
$scriptRoot = "C:\Code\github\DockerVS2015Intro\dockerDemos\00-AzureARM"
cd $scriptRoot

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

# Build fully qualified name
$fqn = $ResourceGroupName.ToLower() + ".northeurope.cloudapp.azure.com"
# Write FQN in config-file for certs
(Get-Content key.template.config).replace('*', $fqn) | Set-Content key.config
# Generate keys for Docker
.\generateKeys.cmd $openssl $fqn
# Read keys as Base64-encoded strings
$content = [IO.File]::ReadAllText("$scriptRoot\ca.pem")
$b  = [System.Text.Encoding]::UTF8.GetBytes($content)
$ca = [System.Convert]::ToBase64String($b)
$content = [IO.File]::ReadAllText("$scriptRoot\server-cert.pem")
$b  = [System.Text.Encoding]::UTF8.GetBytes($content)
$cert = [System.Convert]::ToBase64String($b)
$content = [IO.File]::ReadAllText("$scriptRoot\server-key.pem")
$b  = [System.Text.Encoding]::UTF8.GetBytes($content)
$key = [System.Convert]::ToBase64String($b)

# Trigger deployment
New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
                                   -ResourceGroupName $ResourceGroupName `
                                   -TemplateFile $TemplateFile `
                                   -adminUsername 'training' -adminPassword $secure_string_pwd -dnsNameForPublicIP $ResourceGroupName.ToLower() `
                                   -ubuntuOSVersion '15.10' -storageAccountName $StorageAccountName `
                                   -ca $ca -cert $cert -key $key `
                                   -Force -Verbose

# Copy keys to Docker client for tlsverify
$fqn = $ResourceGroupName.ToLower() + "client.northeurope.cloudapp.azure.com"
.\copyKeys.cmd $putty $fqn

# Just some useful other commands:
# Login-AzureRMAccount
# Get-AzureRmVMImageSku -Location 'northeurope' -Offer 'UbuntuServer' -PublisherName 'Canonical'
# Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force -Verbose

