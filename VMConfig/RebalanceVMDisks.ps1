# Use this script to rebalance the disks into different containers
Param(
  [string]$ResourceGroupName,
  [string]$VMName,
  [string]$StorageAccount,
  [string]$InputFileName
)

#!!! Issue warning  
#!!! print out current configuraiton 
#!!! print out new configuration
#!!! ask for confirmation 

Write-Host "Reading original configuration from file " $InputFileName
$odisks = Get-Content $InputFileName | ConvertFrom-Json

$vm = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -VMName $vmname -Status
$vmstatus = $vm.statuses | Where-Object Code -like "PowerState/deallocated"
if( $vmstatus -eq $null )
{
    Write-Host "VM is running. Please stop the VM and retry this operation"
    exit 
}

# dettach any data disk that might be already attached
$vm = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -VMName $vmname
$cdisks = $vm.StorageProfile.DataDisks
if( $cdisks.Count -gt 0 )
{
    Write-Host "Dettaching all data disks..."
    foreach( $disk in $cdisks )
    {
        Write-Host "Disk " $disk.Name " : " $disk.Vhd.Uri
    }
    $vmchanged = Remove-AzureRmVMDataDisk -VM $vm -DataDiskNames $cdisks.Name
    Write-Host "Updating the VM configuration..."
    $status = Update-AzureRmVM -VM $vm -ResourceGroupName $ResourceGroupName
    #!!! check status
}

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccount
$ctx = New-AzureStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $key.Key1

$cnt = Get-AzureStorageContainer -Name $cname -Context $ctx

foreach( $disk in $odisks )
{
   $uristr = $disk.Vhd.Uri
   $uri = [system.uri] $uristr
   $srccname = $uri.Segments[1].split("/")[0]
   $srcfname = $uri.Segments[2]
   $dstcname = $srcfname.split(".")[0]
   Write-Host "Creating container " $dstcname
   New-AzureStorageContainer -Context $ctx -Name $dstcname
   Write-Host "Copying blob " $srcfname
   Start-CopyAzureStorageBlob -SrcContainer $srccname -SrcBlob $srcfname -DestContainer $dstcname -Context $ctx 
}

#!!! Check if blob copy has completed
#Get-AzureStorageBlobCopyState -Blob $srcfname -Container $dstcname -Context $ctx

$vm = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -VMName $vmname

foreach( $disk in $odisks )
{

   $uristr = $disk.vhd.uri
   $uri = [system.uri] $uristr
   $srccname = $uri.Segments[1].split("/")[0]
   $srcfname = $uri.Segments[2]
   $dstcname = $srcfname.split(".")[0]
   $diskpath = $uri.scheme + "://" + $uri.Host + "/" + $dstcname + "/" + $srcfname
   write-host "Attaching disk " $diskpath
   $vmupdate = Add-AzureRmVMDataDisk -VM $vm -Name $disk.Name -VhdUri $diskpath -CreateOption Attach -Lun $disk.Lun -DiskSizeInGB $disk.DiskSizeGB  
}
Write-Host "Updating the VM..." 
$status = Update-AzureRmVM -VM $vm -ResourceGroupName $ResourceGroupName

# check the status code



