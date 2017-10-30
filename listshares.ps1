Get-AzSStorageShare `
  | select ShareName, HealthStatus, `
           @{Name="TotalGB";Expression={[math]::Round($_.TotalCapacity/1GB,2)}}, `
           @{Name="UsedGB";Expression={[math]::Round($_.UsedCapacity/1GB,2)}}, `
           @{Name="FreeGB";Expression={[math]::Round($_.FreeCapacity/1GB,2)}}, `
           @{Name="Free%";Expression={[math]::Round(($_.FreeCapacity/$_.TotalCapacity)*100,2)}} `
  | format-table