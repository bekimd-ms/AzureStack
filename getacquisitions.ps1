$location = $env:LOCATION

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname

Get-ACSAcquisition -ResourceGroupName $rgname -FarmName $farm.FarmName `
| select AcquisitionId, TenantSubscriptionId, StorageAccountName, Container, Blob, Status, MaximumBlobSize, FilePath | format-table
