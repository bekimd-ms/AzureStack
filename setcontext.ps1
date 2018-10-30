Param(
    [string] $EnvironmentName="", 
    [string] $SubscriptionName=""
)


function global:prompt { Write-Host ("[ $SubscriptionName@$EnvironmentName ] >") -nonewline -foregroundcolor Yellow; return " " }

Import-Module AzureRM -RequiredVersion 2.3.0


$context = get-azurermcontext -listAvailable `
            | where {$_.Subscription.Name -eq $SubscriptionName }  `
            | where {$_.Environment.Name -eq $EnvironmentName  }

if( $context -ne $Null )
{

    $context = Select-AzureRmContext $context.Name
    $host.UI.RawUI.WindowTitle = "$SubscriptionName@$EnvironmentName"
    $global:EnvironmentName = $EnvironmentName
    $global:SubscriptionName = $SubscriptionName
}
else {

    Write-Host "$SubscriptionName@$EnvironmentName does not exist!"
    
}






