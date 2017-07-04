$location = "local"
$planName = "basic" 
$offerName = "basic" 
$rgname = "plansoffers" 

New-AzureRmResourceGroup -Name plansoffers -Location $location

$subid = (Get-AzureRMSubscription).SubscriptionId

$QuotaIds = 
     "/subscriptions/$subid/providers/Microsoft.Compute.Admin/locations/local/quotas/Default Quota",
     "/subscriptions/$subid/providers/Microsoft.Network.Admin/locations/local/quotas/Default Quota",
     "/subscriptions/$subid/providers/Microsoft.Storage.Admin/locations/local/quotas/Default Quota",
     "/subscriptions/$subid/providers/Microsoft.KeyVault.Admin/locations/local/quotas/Unlimited"

Write-Host "Creating a new plan..."
$plan = New-AzsPlan -Name $planName -DisplayName $planName -QuotaIds $QuotaIds -ArmLocation $location -ResourceGroupName $rgname 
Write-Host "New plan created..."
$plan 

Write-Host "Creating a new offer..."
$offer = New-AzsOffer -Name $offerName -DisplayName $offerName -State Public -BasePlanIds $plan.id -ArmLocation $location -ResourceGroupName $rgname
Write-Host "New offer created..."
$offer 


