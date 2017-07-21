foreach($s in (Get-AzureRmSubscription)) 
{
	Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
	Get-AzureRmResourceProvider -ListAvailable | Register-AzureRmResourceProvider -Force
} 