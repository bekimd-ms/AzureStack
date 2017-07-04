Get-AzSStorageAcquisition `
  | select AcquisitionId, TenantSubscriptionId, StorageAccountName, Container, `
    Blob, Status, MaximumBlobSize, FilePath `
  | format-table -AutoSize
