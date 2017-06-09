
$rgs = (get-content .\list.txt | convertfrom-string | where-object { $_.P1 -eq $sub.Subscription.SubscriptionId } )
$rgs.P2 | %{$_.substring(0,$_.indexof('disk'))} | `
          Get-AzureRmResourceGroupDeployment -ResourceGroupName {$_} | `
          select ResourceGroupName, ProvisioningState, TimeStamp | format-table
