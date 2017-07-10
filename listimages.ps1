Param(
  [string]$imagelistfile
)

Import-Module .\AzureStack-Tools\ComputeAdmin\AzureStack.ComputeAdmin.psm1

$list = Import-Csv $imagelistfile
foreach( $item in $list )
{
    Get-AzSVMImage -publisher $item.Publisher -offer $item.Offer -sku $item.SKU -version $item.Version 
}


