Param(
  [string]$starttime,
  [string]$endtime,
  [string]$granularity
)

#"2015-05-02T00:00+00:00Z"
$starttime = $starttime + "T00:00+00:00Z"
$endtime = $endtime + "T00:00+00:00Z"

$starttime, $endtime

$usage = Get-UsageAggregates -ReportedStartTime $starttime -ReportedEndTime $endtime

$agg = $usage[0].UsageAggregations.Properties | select MeterId, Quantity, UsageEndTime, UsageStartTime, InstanceData

