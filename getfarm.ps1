Param(
  [string]$location="local"
)

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$rgname,$farm