Write-host "Downloading tools..."
$path = ".\AzureStack-Tools-master\"
if( Test-Path -Path  $path ) { rmdir -Path $path -Recurse }

Write-host "Installing azure modules"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name AzureRm.BootStrapper -Scope CurrentUser -force
Use-AzureRmProfile -Profile "2017-03-09-profile" -Force
Write-host "Installing azure stack modules"
Install-Module -Name AzureStack -RequiredVersion 1.2.10 -Force

Invoke-webrequest -URI "https://github.com/Azure/AzureStack-Tools/archive/master.zip" -outfile "master.zip"
Expand-Archive ".\master.zip" -DestinationPath .

