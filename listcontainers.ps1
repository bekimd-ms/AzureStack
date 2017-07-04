
$shares = Get-AzSStorageShare 
foreach( $share in $shares )
{
  $containers = Get-AzSStorageContainer -ShareName $share.ShareName -Count 1000
  $containers `
    | select StorageAccountName, ContainerName, ContainerState, UsedBytesInPrimaryVolume, ShareName `
    | format-table
}