Param(
  [string]$rgname,
  [string]$vmsize,
  [string]$password,
  [string]$storageType = "Standard_LRS",
  [string]$disknum = 0, 
  [string]$disksize,
  [string]$vnet = "",
  [string]$vnetrg = "",
  [string]$location = $env:LOCATION

)
Write-Host "Creating resource group..."

new-azurermresourcegroup -name $rgname -location $location
$secret = convertto-securestring -String $password -AsPlainText -Force

if( $vnet -eq "" ) 
{ 
     $type = "publicnet" 
     $template = ".\templates\" + $type + "\vmmultidisk" + $disknum + ".json"
     Write-Host "Template: " $template 
 

     Write-Host "Deploying template in " $rgname "..."
     new-azurermresourcegroupdeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                                        -virtualMachineName $rgname -virtualMachineSize $vmsize -storageType $storageType `
                                        -dataDiskSize $disksize -adminPassword $secret -Location $location 
} 
else
{

     $type = "privatenet" 
     $template = ".\templates\" + $type + "\vmmultidisk" + $disknum + ".json"
     Write-Host "Template: " $template 
 
     Write-Host "Deploying template..."
     new-azurermresourcegroupdeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $template `
                                        -virtualMachineName $rgname -virtualMachineSize $vmsize -storageType $storageType `
                                        -dataDiskSize $disksize -virtualNetworkName $vnet -vnetrg $vnetrg `
                                        -adminPassword $secret -Location $location 
} 

