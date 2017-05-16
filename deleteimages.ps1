Param(
  [string]$username,
  [string]$password
)


Import-Module .\AzureStack-Tools\ComputeAdmin\AzureStack.ComputeAdmin.psm1
$arm = (Get-AzureRmEnvironment -Name AzureStackAdmin).ResourceManagerUrl
$tenId = (Get-AzureRmSubscription).TenantId
$secret = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secret

$list = Import-Csv "imagelist.csv" 
foreach( $item in $list )
{
    $item
    Remove-VMImage -publisher $item.Publisher -offer $item.Offer -sku $item.SKU -version $item.Version -tenantID $tenId -azureStackCredentials $cred -ArmEndpoint $arm 
}