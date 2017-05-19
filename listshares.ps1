$location = $env:LOCATION

$rgname = "system." + $location
$farm = Get-ACSFarm -ResourceGroupName $rgname
$shares = Get-ACSShare -ResourceGroupName $rgname -FarmName $farm.FarmName

$shares | Format-Table