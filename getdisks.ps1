Get-Azsdisk -Status All |  select `
      Status, `
      DiskType, `
      ProvisionSizeGB, `
      ActualSizeGB, `
      @{Name="Volume";Expression={ $m = $_.SharePath -match "\\\\.*\\(.*)"; $matches[1] }}, `
      @{Name="VMSubscription";Expression={ $m = $_.ManagedBy -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/virtualMachines/(.*)"; $matches[1] }}, `
      @{Name="VMResourceGroup";Expression={ $m = $_.ManagedBy -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/virtualMachines/(.*)"; $matches[2] }}, `
      @{Name="VMName";Expression={ $m = $_.ManagedBy -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/virtualMachines/(.*)"; $matches[3] }}, `
      @{Name="DiskName";Expression={ $m = $_.UserResourceId -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/Disks/(.*)"; $matches[3] }}, `
      @{Name="DiskResourceGroup";Expression={ $m = $_.UserResourceId -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/Disks/(.*)"; $matches[2] }}, `
      @{Name="DiskSubscription";Expression={ $m = $_.UserResourceId -match "/subscriptions/(.*)/resourceGroups/(.*)/providers/Microsoft.Compute/Disks/(.*)"; $matches[1] }}, `
      DiskSku `
| sort Volume, VMSubscription, VMResourceGroup, VMName, DiskName, DiskType



