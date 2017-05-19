Param(
  [string]$username,
  [string]$password,
  [string]$imagelistfile,
  [string]$location="local"
)

if( $username -eq "" )
{
    $username = $env:USER + "@" + $env:DIRECTORY
    $password = $env:PASSWORD
    $location = $env:LOCATION    
}

Import-Module .\AzureStack-Tools\ComputeAdmin\AzureStack.ComputeAdmin.psm1
$tenId = (Get-AzureRmSubscription).TenantId
$secret = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secret
$environment = $location 

$list = Import-Csv $imagelistfile
foreach( $item in $list )
{
    $item
    Add-VMImage2 -publisher $item.Publisher -offer $item.Offer -sku $item.SKU -version $item.Version -osType $item.Type -osDiskBlobUri $item.URI -tenantID $tenId -azureStackCredentials $cred -Environment $environment -verbose -location $location
}