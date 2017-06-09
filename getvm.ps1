Param(
  [string]$state="",
  [string]$subname=""
)

function GetSubVms( $state )
{
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

if( $subname -eq "" ) 
{
  $subs = get-azurermsubscription 
  foreach( $sub in $subs )
  {
     Write-Host
     Write-Host $sub.SubscriptionName
     select-azurermsubscription -SubscriptionId $sub.SubscriptionId
     GetSubVms $state
  }
}
else
{
  Write-Host
  Write-Host $subname
  select-azurermsubscription -SubscriptionName $subname
  GetSubVms $state
}