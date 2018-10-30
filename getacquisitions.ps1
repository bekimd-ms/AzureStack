$farm = Get-AzsStorageFarm
Get-AzSStorageAcquisition -FarmName $farm.Name `
  | select AcquisitionId,  @{Name="Volume";Expression={$_.FilePath.substring(18,8)}}, SusbcriptionId, Storageaccount, Container, `
    Blob, Status, MaximumBlobSize, FilePath `
  | sort Volume 
