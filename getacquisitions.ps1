$farm = Get-AzsStorageFarm
Get-AzSStorageAcquisition -FarmName $farm.Name `
  | select @{Name="Volume";Expression={$_.FilePath.substring(32,16)}}, SusbcriptionId, Storageaccount, Container, Blob, `
    Status, MaximumBlobSize, AcquisitionId,  FilePath `
  | sort Volume, SusbcriptionId, StorageAccount, Container, Blob `
  | ft
