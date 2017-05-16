

Import-module AzureRM -RequiredVersion 1.2.9
Import-Module .\AzureStack-Tools\Connect\AzureStack.Connect.psm1

$secret = convertto-securestring -String $env:PASSWORD -AsPlainText -Force
$user = $env:USER + "@" + $env:DIRECTORY
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $secret
$environment = $env:LOCATION
$endpoint = "https://" + $env:ENDPOINT + "management." + $env:LOCATION + "." + $env:DNS

Write-Host "Adding Environment: " $environment ":" $endpoint
Add-AzureStackAzureRmEnvironment -Name $environment -ArmEndpoint $endpoint
Write-Host "Logging in:" $user
Login-AzureRMAccount -EnvironmentName $environment -Credential $cred      

Write-Host "Logged in:" $environment $user

