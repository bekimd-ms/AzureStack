Param(
  [string]$username,
  [string]$password,
  [string]$location="local"
)

if( $username -eq "" )
{
    $username = $env:USER + "@" + $env:DIRECTORY
    $password = $env:PASSWORD
    $location = $env:LOCATION    
}

$environment = $location

Import-Module .\AzureStack-Tools\ServiceAdmin\AzureStack.ServiceAdmin.psm1
$tenId = (Get-AzureRmSubscription).TenantId
$secret = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secret

New-AzSTenantOfferAndQuotas -Name xxl -Location $location -EnvironmentName $environment -TenantId $tenId -azureStackCredential $cred 

