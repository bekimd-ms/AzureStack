Param(
  [string]$imagelistfile
)

Import-Module .\AzureStack-Tools\ComputeAdmin\AzureStack.ComputeAdmin.psm1

$list = Import-Csv $imagelistfile
foreach( $item in $list )
{
    $item
    Add-AzSVMImage -publisher $item.Publisher -offer $item.Offer -sku $item.SKU -version $item.Version -osType $item.Type -osDiskBlobUri $item.URI -verbose

}


