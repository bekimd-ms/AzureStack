$location = $env:LOCATION

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$rgname,$farm