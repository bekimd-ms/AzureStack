Get-AzSStorageShare `
  | select ShareName, HealthStatus, TotalCapacity, UsedCapacity, FreeCapacity `
  | format-table