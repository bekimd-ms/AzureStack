Param(
  [string]$rgname,
  [string]$vmsize,
  [string]$disknum, 
  [string]$disksize,
  [string]$vnet = "",
  [string]$vnetrg = "",
  [string]$location = "local"
)
Write-Host "Creating resource group..."


new-azurermresourcegroup -name $rgname -location $location
$password = "1Add*Pass"
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

