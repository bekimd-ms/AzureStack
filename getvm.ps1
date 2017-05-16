Param(
  [string]$state=""
)

$subs = get-azurermsubscription 
foreach( $sub in $subs )
{
   Write-Host
   Write-Host $sub.SubscriptionName

   $s = select-azurermsubscription -SubscriptionId $sub.SubscriptionId
   if( $state -eq "" )
   {
      $vms = ( get-azurermvm ) 
   }
   else
   {
      $vms = ( get-azurermvm | where {$_.ProvisioningState -eq $state } )
   }

   Write-Host "# " $vms.Count
   foreach( $vm in $vms )
   {
     Write-Host $vm.Name $vm.ProvisioningState $vm.StorageProfile.OSDisk.Vhd.Uri 
   }
}
