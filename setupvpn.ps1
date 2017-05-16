Param(
  [string]$hostIP,
  [string]$pass,
  [string]$name
)

Import-Module  .\AzureStack-Tools\Connect\AzureStack.Connect.psm1
Set-Item wsman:\localhost\Client\TrustedHosts -Value $hostIP -Concatenate
Set-Item wsman:\localhost\Client\TrustedHosts -Value azs-ca01.azurestack.local -Concatenate

$Password = ConvertTo-SecureString $pass -AsPlainText -Force

$natIP = Get-AzureStackNatServerAddress -HostComputer $hostIP -Password $Password

# Create VPN connection entry for the current user
Add-AzureStackVpnConnection -ConnectionName $name -ServerAddress $natIP -Password $Password

# Connect to the Azure Stack instance. This command can be used multiple times.
Connect-AzureStackVpn -ConnectionName $name -Password $Password

