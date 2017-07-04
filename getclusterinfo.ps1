

while( $true )
{

   $timestamp = get-date -Format o
   Write-Host "-----------------------------------------------------------------------"
   Write-Host $timestamp
   Write-Host ""

   Write-Host "Getting cluster nodes"

   $nodes = get-clusternode -Cluster S-Cluster
   $data = $nodes | select * 
   $data | add-member -Type NoteProperty -Name Timestmap -value (get-date -Format o)
   $data | export-csv -path "nodes.csv" -NoTypeInformation -Append 

   Write-Host "Getting cluster volumes"  
   $vol = Get-ClusterSharedVolume -Cluster S-cluster
   $data = $vol | select * 
   $data | add-member -Type NoteProperty -Name Timestmap -value (get-date -Format o)
   $data | export-csv -path "volumes.csv" -NoTypeInformation -Append 

   Write-Host "Getting cluster VMs"  
   $vm = @()
   foreach( $node in $nodes )
   {
      Write-host "Loading VMs from node " $node.Name
      $vm += @(get-vm -ComputerName $node.Name)
   }

   Write-host "Exporting VM info " 

   $data = $vm | select *  
   $data | add-member -Type NoteProperty -Name Timestmap -value (get-date -Format o)
   $data | export-csv -path "vms.csv" -NoTypeInformation -Append 

}