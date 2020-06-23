Import-Module AzureRM -MaximumVersion 2.9.9

Get-AzureRmContext -ListAvailable `
   | select @{Name="Environment";Expression={$_.Environment.Name}}, @{Name="Subscription";Expression={$_.Subscription.Name}} `
   | sort Environment,Subscription

