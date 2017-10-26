$vols = Get-ClusterSharedVolume -Cluster S-Cluster

del volumes.csv
del partitions.csv
del objstore.csv
del tempstore.csv
del infrastore.csv

function DumpShareData( $shares, $sharePrefix, $filename )
{
  $i=1
  foreach( $share in $shares )
  {  
    Write-Host ""
    Write-Host $s
    Write-Host $share.name $share.ownernode.name
    Write-Host ([math]::round(($share.SharedVolumeInfo.Partition.Size/$gb),2)) "GiB   " ([math]::round(($share.SharedVolumeInfo.Partition.UsedSpace/$gb),2)) "GiB"
    Write-Host ""
    $path = ($share.SharedVolumeInfo.FriendlyVolumeName + "\Shares\" + $sharePrefix + ($i++))
    $pathparts = $path.split( ":")
    $path = "\\" + $share.ownernode.name + "\" + $pathparts[0] + "$" + $pathparts[1]
    Write-Host $path
    $files = Get-ChildItem -Path $path -Recurse
    $files | select Name, Extension, PSIsContainer, Parent, Length, FullName | export-csv -Path $filename -Append -NoTypeInformation
  }

}

$vols | select id, Name -ExpandProperty SharedVolumeInfo | export-csv -Path "volumes.csv" -NoTypeInformation
$vols | select id -ExpandProperty SharedVolumeInfo | select id -ExpandProperty Partition | Export-csv -Path "partitions.csv" -NoTypeInformation

$gb = (1024 * 1024 * 1024)

$objshares = $vols | where Name -like "*Obj*"
Write-Host
Write-Host "ObjStore shares..."
DumpShareData $objshares "SU1_ObjStore_" "objstore.csv"

$tempshares = $vols | where Name -like "*Temp*"
Write-Host
Write-Host "Temp shares..."
DumpShareData $tempshares "SU1_VMTemp_" "tempstore.csv"

$infrashares = $vols | where Name -like "*Infra*"
Write-Host
Write-Host "Temp shares..."
DumpShareData $infrashares "SU1_Infrastructure_" "infrastore.csv"

