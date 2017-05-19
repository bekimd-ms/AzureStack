$location = $env:LOCATION

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$shares = Get-ACSShare -ResourceGroupName $rgname -FarmName $farm.FarmName
foreach( $share in $shares )
{
  $share
  $containers = Get-ACSContainer -ResourceGroupName $rgname -FarmName $farm.FarmName -ShareName $share.ShareName -Count 1000
  $containers | select StorageAccountName, ContainerName, ContainerState, UsedBytesInPrimaryVolume, ShareName | format-table
}