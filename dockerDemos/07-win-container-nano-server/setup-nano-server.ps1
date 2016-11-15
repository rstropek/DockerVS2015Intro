# For details see https://technet.microsoft.com/en-us/library/mt126167.aspx

Import-Module Hyper-V

# Location where the Windows Server 2016 ISO is mounted. We will copy the
# Nano Server Image Generator from there.
$winServerInstallRoot = "d:\"
$temp = "c:\temp"
$nanoServerImageGeneratorFolder = "$temp\NanoServerImageGenerator"
$targetPath = $temp + "\NanoServerVM.vhd"
$computerName = "dockerhost"
$secure_string_pwd = convertto-securestring "pass" -asplaintext -force
$vmSwitch = "External"
[Environment]::SetEnvironmentVariable("TEMP", "c:\temp\tempFolder", "Process")

# Stop and remove existing VM
$vm = Get-VM -Name $computerName -ErrorAction SilentlyContinue
if ($vm) {
    Stop-VM -VM $vm -ErrorAction SilentlyContinue
    Remove-VM -VM $vm -Force
}

# Remove target ISO file
if (Test-Path -Path "$targetPath") {
    Remove-Item $targetPath -Force
}

# Copy Nano Server Image Generator to local disk
if (!(Test-Path -Path "$nanoServerImageGeneratorFolder")) {
    Copy-Item "$winServerInstallRoot\NanoServer\NanoServerImageGenerator" "$nanoServerImageGeneratorFolder" -Recurse -Force
}

# Import Nano Generator module
cd $nanoServerImageGeneratorFolder
Import-Module .\NanoServerImageGenerator -Verbose

# Create Nano Server ISO image
New-NanoServerImage -Edition Standard -DeploymentType Guest -MediaPath $winServerInstallRoot `
    -BasePath .\Base -TargetPath $targetPath -ComputerName $computerName -AdministratorPassword $secure_string_pwd `
    -ServicingPackagePath "C:\Users\r.stropek\Downloads\ServiceUpdates\Windows10.0-KB3197954-x64.cab", `
        "C:\Users\r.stropek\Downloads\ServiceUpdates\Windows10.0-KB3199986-x64.cab", `
        "C:\Users\r.stropek\Downloads\ServiceUpdates\Windows10.0-KB3200970-x64.cab" `
    -Package Microsoft-NanoServer-Guest-Package -MaxSize 100GB `
    -Compute -Containers -EnableRemoteManagementPort -Verbose

# Create and start VM with new Nano Server image
$vm = New-VM -Name $computerName -VHDPath $targetPath -Generation 1 -Verbose -MemoryStartupBytes 2GB -SwitchName $vmSwitch
Start-VM $vm 
do {
    $vmIP = (Get-VMNetworkAdapter $vm)[0].IPAddresses[0]
    if (!$vmIP) {
        Start-Sleep -Seconds 2
    }
}
until ($vmIP)

# Open session to VM
net start WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts $vmIP -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "Administrator", $secure_string_pwd
$session = New-PSSession -ComputerName $vmIP -Credential $cred

# Copy docker to vm and install it
Invoke-Command -Session $session -ScriptBlock { netsh advfirewall firewall add rule name="Docker daemon" dir=in action=allow protocol=TCP localport=2375 }
Invoke-Command -Session $session -ScriptBlock { netsh advfirewall firewall add rule name="HTTP" dir=in action=allow protocol=TCP localport=80 }
Invoke-Command -Session $session -ScriptBlock { Install-Module -Name DockerMsftProvider -Repository PSGallery -Force }
Invoke-Command -Session $session -ScriptBlock { Install-Package -Name docker -ProviderName DockerMsftProvider }
Invoke-Command -Session $session -ScriptBlock { Start "C:\Program Files\Docker\dockerd.exe" --register-service }
Invoke-Command -Session $session -ScriptBlock { new-item -Type File c:\ProgramData\docker\config\daemon.json }
Invoke-Command -Session $session -ScriptBlock { Add-Content 'c:\programdata\docker\config\daemon.json' '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }' }
Restart-VM $vm

# That's it. Nano Server with Docker is running and listening on port 2375

# Helper commands
# Enter-PSSession -Session $session
