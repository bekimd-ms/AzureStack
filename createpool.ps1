Import-Module Storage

Get-PhysicalDisk -CanPool $true

$pool = New-StoragePool -FriendlyName "DataPool" `
-StorageSubSystemUniqueId (Get-StorageSubSystem)[0].uniqueID `
-PhysicalDisks (Get-PhysicalDisk -CanPool $true)

$pool

$vdisk = New-VirtualDisk -FriendlyName "DataDisk" `
-StoragePoolFriendlyName "DataPool" -UseMaximumSize `
-ResiliencySettingName Simple

$disknum = ($vdisk | Get-Disk ).Number
Initialize-Disk $disknum

$part = New-Partition -DiskNumber $disknum -UseMaximumSize -DriveLetter "F"

Format-Volume -DriveLetter $part.DriveLetter -FileSystem NTFS -NewFileSystemLabel "DataVolume"


