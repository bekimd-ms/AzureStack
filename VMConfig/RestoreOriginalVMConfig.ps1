Param(
  [string]$ResourceGroupName,
  [string]$VMName,
  [string]$InputFileName
)

#!!! Issue warning  
#!!! print out current configuraiton 
#!!! print out new configuration
#!!! ask for confirmation 


Write-Host "Reading original configuration from file " $InputFileName
$odisks = Get-Content $InputFileName | ConvertFrom-Json

$vm = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -VMName $vmname -Status
$vmstatus = $vm.statuses | Where-Object Code -like "PowerState/Deallocated"
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
    $vmchange = Remove-AzureRmVMDataDisk -VM $vm -DataDiskNames $cdisks.Name
    Write-Host "Updating the VM configuration..."
    $status = Update-AzureRmVM -VM $vm -ResourceGroupName $ResourceGroupName
    #!!! check status
}


foreach( $disk in $odisks )
{
   Write-Host "Attaching disk " $disk.Name " " $disk.Vhd.Uri
   $vmchange = Add-AzureRmVMDataDisk -VM $vm -Name $disk.Name -VhdUri $disk.Vhd.Uri -CreateOption Attach -Lun $disk.Lun -DiskSizeInGB $disk.DiskSizeGB     
}

$status = Update-AzureRmVM -VM $vm -ResourceGroupName $ResourceGroupName
#!!! check status



