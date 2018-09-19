Param(
  [string]$starttime,
  [string]$endtime,
  [string]$granularity
)


Write-Host "Usage per subscription for period from " $starttime "to" $endtime

$subs = Get-AzsUserSubscription 
$usage = Get-AzsSubscriberUsage -ReportedStartTime $starttime -ReportedEndTime $endtime -AggregationGranularity $granularity

$subusage = $usage | group SubscriptionId 

$usagedata = @()
foreach( $sub in $subusage )
{
    
    $subinfo = $subs | where SubscriptionId -eq $sub.Name
    Write-Host $sub.Name, $subInfo.DisplayName, $subInfo.Owner
    foreach( $item in $sub.Group)
    {
        #Write-Host $item.InstanceData
        $data = ($item.InstanceData | convertfrom-json).'Microsoft.resources'
        $m = $data.resourceUri -match "resourceGroups/(.*)/providers/(.*)/(.*)/(.*)"
     
        $usagerec = New-Object PSObject -Property @{
            Subscriptionid = $sub.Name
            SubscriptionName = $subInfo.DisplayName
            SubscriptionOwner = $subInfo.Owner
            StartTime = $item.UsageStartTime
            EndTime   = $item.UsageEndTime
            ResourceGroup = $matches[1]
            Provider = $matches[2]
            ResourceType = $matches[3]
            ResourceName = $matches[4]
            MeterId = $item.MeterId
            Name = $item.Name
            Quantity = $item.Quantity 
            Info = $data.additionalInfo
        }

        $usagedata += @($usagerec)
    }

}

$usagedata