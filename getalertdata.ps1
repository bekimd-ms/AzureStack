Param(
  [string]$FromTime, 
  [string]$ToTime
)

Write-Host "Exporting alert data..."
Get-AzsAlert | Export-Csv -Path azs-alerts.csv -NoTypeInformation


Write-Host "Getting metrics..."
$metrics = Get-AzsBlobServiceMetric -TimeGrain Minutely -StartTimeInUtc $FromTime -EndTimeInUtc $ToTime


foreach( $metric in $metrics )
{
    Write-Host "Exporting values for " $metric.Name 
    $metric.MetricValues | export-csv -path ("azs-alerts-" + $metric.Name + ".csv") -NoTypeInformation
}

Compress-Archive -Path azs-alerts*.csv -DestinationPath .\alertdata.zip -Force

del azs-alerts*.csv
