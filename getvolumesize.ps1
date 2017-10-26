$vols = Get-ClusterSharedVolume -Cluster S-Cluster
$vols.SharedVolumeInfo `
  | select FriendlyVolumeName -ExpandProperty Partition `
  | select FriendlyVolumeName, PercentFree, @{Name="UsedGB";Expression={[math]::Round($_.UsedSpace/1GB,2)}}