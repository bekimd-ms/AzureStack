param(
  [int] $diskNumber = 1
)

$template = Get-Content -Raw -Path .\templates\vmmultidisk.json | convertfrom-json

$disks = $template.resources[0].properties.storageProfile.dataDisks
$disk = $disks[0]

$disksC = {}.Invoke()

for( $i=1;$i -le $diskNumber; $i++ ) 
{
   $newDisk = "disk" + $i 
   $newContainer = "vhds" + $i
   $newDisk, $newContainer

   $disk

   $diskR = $disk
   $diskR.name = $disk.name.Replace( "disk1", $newDisk )
   $diskR.name

   $diskR.vhd.uri = $disk.vhd.uri.Replace( "vhds1", $newContainer ).Replace( "disk1", $newDisk )
   $diskR.vhd.uri
 
   $disksC.Add( $diskR );
}


$template.resources[0].properties.storageProfile.dataDisks = $disksC

convertto-json -depth 100 $template | Out-File .\vmmultidisk.json
