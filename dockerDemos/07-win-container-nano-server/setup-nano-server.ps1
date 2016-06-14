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
    -Packages Microsoft-NanoServer-Guest-Package -MaxSize 100GB `
    -Compute -Clustering -Containers -EnableRemoteManagementPort -Verbose

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

# Download Docker (for details see https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment_nano
# and https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server)
if (!(Test-Path -Path "$temp\dockerd.exe")) {
    Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile "$temp\dockerd.exe"
}
if (!(Test-Path -Path "$temp\docker.exe")) {
    Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile "$temp\docker.exe"
}

# Open session to VM
net start WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts $vmIP -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "Administrator", $secure_string_pwd
$session = New-PSSession -ComputerName $vmIP -Credential $cred

# Copy docker to vm and install it
Invoke-Command -Session $session -ScriptBlock { New-Item -Type Directory -Path 'C:\docker\' }
Copy-Item -ToSession $session "$temp\dockerd.exe" 'C:\docker\'
Copy-Item -ToSession $session "$temp\docker.exe" 'C:\docker\'
Invoke-Command -Session $session -ScriptBlock { netsh advfirewall firewall add rule name="Docker daemon" dir=in action=allow protocol=TCP localport=2375 }
Invoke-Command -Session $session -ScriptBlock { netsh advfirewall firewall add rule name="HTTP" dir=in action=allow protocol=TCP localport=80 }
Invoke-Command -Session $session -ScriptBlock { new-item -Force -type File c:\ProgramData\docker\config\daemon.json -value '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }' }
Invoke-Command -Session $session -ScriptBlock { C:\docker\dockerd.exe --register-service; Start-Service Docker }

# Download and install Nano Server container image
Invoke-Command -Session $session -ScriptBlock { Install-PackageProvider ContainerImage -Force  }
Invoke-Command -Session $session -ScriptBlock { Install-ContainerImage -Name NanoServer -Verbose -Force }
Invoke-Command -Session $session -ScriptBlock { Restart-Service Docker }
Invoke-Command -Session $session -ScriptBlock { c:\docker\docker.exe tag nanoserver:10.0.14300.1016 nanoserver:latest }

# That's it. Nano Server with Docker is running and listening on port 2375


# Helper commands
# Enter-PSSession -Session $session
