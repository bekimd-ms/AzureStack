Get-Azsdisk -Status All |  select `
      Status, 

      @{Name="Volume";Expression={ $m = $_.SharePath -match "\\\\.*\\(.*)"; $matches[1] }}, `
      @{Name="VM";Expression={ $m = $_.ManagedBy -match "/.*/(.*)"; $matches[1] }}, `
      @{Name="Disk";Expression={ $m = $_.UserResourceId -match "/.*/(.*)"; $matches[1] }}, `
      ProvisionSizeGB, `
      ActualSizeGB, `
      DiskSku `
| sort Volume