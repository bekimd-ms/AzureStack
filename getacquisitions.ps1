Get-AzSStorageAcquisition `
  | select AcquisitionId,  @{Name="Volume";Expression={$_.FilePath.substring(18,8)}}, TenantSubscriptionId, StorageAccountName, Container, `
    Blob, Status, MaximumBlobSize, FilePath `
  | sort Volume `
  | format-table -AutoSize
