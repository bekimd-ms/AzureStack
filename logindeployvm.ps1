Param(
  [string]$location = "",
  [string]$dns = "",
  [string]$user = "",
  [string]$pwd = "",
  [string]$sub = "",
  [string]$rgname,
  [string]$vmsize,
  [string]$disknum, 
  [string]$disksize,
  [string]$vnet = "",
  [string]$vnetrg = ""
)

Write-host "Creating environment..."
Import-Module ".\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1"

$endpoint = "https://management." + $location + "." + $dns
$env = "AzureStackTenant"
Add-AzureStackAzureRmEnvironment -Name $env -ArmEndpoint $endpoint

$secret = convertto-securestring -String $pwd -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $secret

Write-Host "Logging in..."

Login-AzureRMAccount -EnvironmentName $env -Credential $cred

Select-AzureRMSubscription -SubscriptionName $sub
Write-Host "Creating resource group..."

new-azurermresourcegroup -name $rgname -location $location
$password = ""
$secret = convertto-securestring -String $password -AsPlainText -Force

if( $vnet -eq "" ) 
{ 
     $type = "publicnet" 
     $template = ".\templates\" + $type + "\vmmultidisk" + $disknum + ".json"
     Write-Host "Template: " $template 
 

     Write-Host "Deploying template..."
     new-azurermresourcegroupdeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                                        -virtualMachineName $rgname -virtualMachineSize $vmsize -dataDiskSize $disksize `
                                        -adminPassword $secret -Location $location
} 
else
{

     $type = "privatenet" 
     $template = ".\templates\" + $type + "\vmmultidisk" + $disknum + ".json"
     Write-Host "Template: " $template 
 
     Write-Host "Deploying template..."
     new-azurermresourcegroupdeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                                        -virtualMachineName $rgname -virtualMachineSize $vmsize -dataDiskSize $disksize `
                                        -virtualNetworkName $vnet -vnetrg $vnetrg `
                                        -adminPassword $secret -Location $location 
} 

start-sleep 10