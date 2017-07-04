Param(
  [string]$hostIP,
  [string]$pass,
  [string]$name
)

Import-Module  .\AzureStack-Tools\Connect\AzureStack.Connect.psm1
Set-Item wsman:\localhost\Client\TrustedHosts -Value $hostIP -Concatenate

$Password = ConvertTo-SecureString $pass -AsPlainText -Force

# Create VPN connection entry for the current user
Add-AzSVpnConnection -ConnectionName $name -ServerAddress $hostIP -Password $Password

# Connect to the Azure Stack instance. This command can be used multiple times.
Connect-AzSVpn -ConnectionName $name -Password $Password

