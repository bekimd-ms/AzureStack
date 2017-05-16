Param(
  [string]$rgname,
  [string]$template,
  [string]$location = "local"
)

$templateroot = ".\ACS\" + $template 
$templatefile = $templateroot + "\azuredeploy.json"
$templateparamfile = $templateroot + "\azuredeploy.parameters.json"
new-azurermresourcegroup -name $rgname -location $location
new-azurermresourcegroupdeployment -verbose -name $rgname -resourcegroupname $rgname -templatefile $templatefile -templateparameterfile $templateparamfile 

