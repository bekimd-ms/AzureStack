Import-Module AzureRM -RequiredVersion 2.3.0

Get-AzureRmContext -ListAvailable `
   | select @{Name="Environment";Expression={$_.Environment.Name}}, @{Name="Subscription";Expression={$_.Subscription.Name}} `
   | sort Environment,Subscription

