# Location where the Windows Server 2016 ISO is mounted. 
# We will copy the Nano Server Image Generator from there.
$winServerInstallRoot = "d:\"
$temp = "c:\temp"
$nanoServerImageGeneratorFolder = "$temp\NanoServerImageGenerator"
$targetPath = $temp + "\demo\NanoServerVM.vhd"
$computerName = "mynanoserver"
$secure_string_pwd = convertto-securestring "pass" -asplaintext -force
[Environment]::SetEnvironmentVariable("TEMP", "c:\temp\tempFolder",`
	"Process")

# Copy Nano Server Image Generator to local disk
if (!(Test-Path -Path "$nanoServerImageGeneratorFolder")) {
	Copy-Item "$winServerInstallRoot\NanoServer\NanoServerImageGenerator" `
 		"$nanoServerImageGeneratorFolder" -Recurse -Force
}

# Import Nano Generator module
cd $nanoServerImageGeneratorFolder
Import-Module .\NanoServerImageGenerator -Verbose

# Create Nano Server VHD
New-NanoServerImage -Edition Standard -DeploymentType Guest `
	-MediaPath $winServerInstallRoot `
	-BasePath .\Base -TargetPath $targetPath -ComputerName $computerName `
	-AdministratorPassword $secure_string_pwd `
	-Package Microsoft-NanoServer-Guest-Package -MaxSize 100GB `
	-EnableRemoteManagementPort -Verbose
