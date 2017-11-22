# Check if user is already signed in
Try {
  Get-AzureRmContext | Out-Null
} Catch {
  if ($_ -like "*Login-AzureRmAccount to login*") {
    Login-AzureRmAccount
  }
}

# Select subscription where name contains `MSDN Subscription`
Get-AzureRmSubscription | where { $_.SubscriptionName -like "*MSDN Subscription*" } | Select-AzureRmSubscription

$path = "C:\Code\GitHub\DockerVS2015Intro\dockerDemos\10-aks-dotnet"
$TemplateFile = 'aci.json'
$ResourceGroupName = 'AciDemo01'
$location = "westeurope"

$cred = Get-Credential

$group = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (!$group) {
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $location
}

# Trigger deployment
New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem "$path\$TemplateFile").BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile "$path\$TemplateFile" `
    -imageRegistryLoginServer 'rainer.azurecr.io' -imageRegistryUsername $cred.UserName `
    -imageRegistryPassword $cred.Password `
    -Force -Verbose
