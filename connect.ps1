Import-Module AzureRM -RequiredVersion 2.3.0
#Import-Module .\AzureStack-Tools\Connect\AzureStack.Connect.psm1

$environment = $env:LOCATION
$endpoint = "https://" + $env:ENDPOINT + "management." + $env:LOCATION + "." + $env:DNS

Write-Host "Adding Environment: " $environment ":" $endpoint
Add-AzureRmEnvironment -Name $environment -ArmEndpoint $endpoint

if( $env:USER -eq $Null )
{
  $user = ""
  Login-AzureRMAccount -EnvironmentName $environment -TenantId $env:DIRECTORY
}
else
{
  $secret = convertto-securestring -String $env:PASSWORD -AsPlainText -Force
  $user = $env:USER + "@" + $env:DIRECTORY
  $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $secret

  Write-Host "Logging in:" $user
  Login-AzureRMAccount -EnvironmentName $environment -Credential $cred   
}

Write-Host "Logged in:" $environment $user

