Param(
  [string]$location="local"
)

del shares.csv
del containers.csv
$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$shares = Get-ACSShare -ResourceGroupName $rgname -FarmName $farm.FarmName
$shares | export-csv -Path shares.csv
foreach( $share in $shares )
{
  $share
  $containers = Get-ACSContainer -ResourceGroupName $rgname -FarmName $farm.FarmName -ShareName $share.ShareName -Count 1000
  $containers | export-csv -Path containers.csv -Append
}