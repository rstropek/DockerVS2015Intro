Import-Module Hyper-V
net start WinRM

$computerName = "Simple Nano Server"

$vm = Get-VM -Name $computerName
$vmIP = (Get-VMNetworkAdapter $vm)[0].IPAddresses[0]

Set-Item WSMan:\localhost\Client\TrustedHosts $vmIP -Force
$cred = Get-Credential
$session = New-PSSession -ComputerName $vmIP -Credential $cred
Enter-PSSession -Session $session
