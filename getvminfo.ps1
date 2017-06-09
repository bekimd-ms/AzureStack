$nodes = get-clusternode -Cluster S-Cluster

$vm = @()
foreach( $node in $nodes )
{
  Write-host "Loading VMs from node " $node.Name
  $vm += @(get-vm -ComputerName $node.Name)
}

$vm

$vm | select ComputerName, Name, Notes, State, Path, ConfigurationLocation, `
             CheckpointFileLocation, DynamicMemoryEnabled, MemoryStartup, `
             MemoryMinimum, MemoryMaximum `
    | export-csv -path "vmlist.csv" -NoTypeInformation

$hd = $vm.HardDrives 
$hd | export-csv -path "disklist.csv" -NoTypeINformation

$vol = Get-ClusterSharedVolume -Cluster S-cluster
$vol | %{ new-object psobject -Property @{ Name=$_.Name; Node=$_.OwnerNode; `
            Volume=$_.SharedVolumeInfo.FriendlyVolumeName; Size=$_.SharedVolumeInfo.Partition.Size; `
            Used=$_.SharedVolumeInfo.Partition.UsedSpace; Percent=$_.SharedVolumeInfo.Partition.PercentFree } } `
     | export-csv -path "shares.csv" -NoTypeINformation
     

$dir = Get-ChildItem '\\node01\c$\ClusterStorage\VolumeN' -recurse
$dir | where-object { $_.Attributes -ne "Directory" } | select * | export-csv -path t1files.csv -NoTypeInformation


Get-VM | Measure-VM | select VMName,
    @{Label='TotalIO';Expression = {$_.AggregatedDiskDataRead + $_.AggregatedDiskDataWritten}},
    @{Label='%Read';Expression={"{0:P2}" -f ($_.AggregatedDiskDataRead/($_.AggregatedDiskDataRead + $_.AggregatedDiskDataWritten))}},
    @{Label='%Write';Expression={"{0:P2}" -f ($_.AggregatedDiskDataWritten/($_.AggregatedDiskDataRead + $_.AggregatedDiskDataWritten))}},
    @{Label='TotalIOPS';Expression = {"{0:N2}" -f (($_.AggregatedDiskDataRead + $_.AggregatedDiskDataWritten)/$_.MeteringDuration.Seconds)}}
