Param(
  [string]$location="local"
)

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$shares = Get-ACSShare -ResourceGroupName $rgname -FarmName $farm.FarmName

$shares | Format-Table