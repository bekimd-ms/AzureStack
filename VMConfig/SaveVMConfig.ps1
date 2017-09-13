Param(
  [string]$ResourceGroupName,
  [string]$VMName,
  [string]$OutputFileName
)

$vm = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -VMName $VMName
$vm.StorageProfile.DataDisks | ConvertTo-Json | Out-File $OutputFileName

$cdisks = $vm.StorageProfile.DataDisks
if( $cdisks.Count -gt 0 )
{
    foreach( $disk in $cdisks )
    {
        Write-Host "Disk: " $disk.Name " : " $disk.Vhd.Uri
    }
}

Write-Host "VM data disk configuration saved in file " $OutputFileName

