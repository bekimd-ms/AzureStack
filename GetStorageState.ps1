Param(
  [string]$ERCSHostIp,
  [string]$CloudAdminDomainUser,
  [string]$CloudAdminPassword,
  [string]$HLHLogPath,
  [string]$HLHAdminUser="Administrator",
  [string]$HLHAdminPassword
)

$pwd= ConvertTo-SecureString $CloudAdminPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($CloudAdminDomainUser, $pwd)

Write-Host "Establishing remote session to " $ERCSHostIp
$s = New-PSSession -ComputerName $ERCSHostIp -ConfigurationName PrivilegedEndpoint -Credential $cred

$sharepwd = ConvertTo-SecureString $HLHAdminPassword -AsPlainText -Force
$sharecred = New-Object System.Management.Automation.PSCredential ($HLHAdminUser, $pwd)

Write-Host "Running Test-AzureStack" 
Invoke-Command -Session $s {  Test-AzureStack -Include AzsStorageSvcsSummary, AzsHostingInfraSummary }

$fromDate = (Get-Date).AddMinutes(-15)
$toDate = (Get-Date) 


Write-Host "Running Get-AzureStackLog" 
$result = Invoke-Command -Session $s {  `
                Get-AzureStackLog -OutputPath $using:HLHLogPath"\Temp" `
                       -OutputSharePath $using:HLHLogPath `
                       -OutputShareCredential $using:shareCred `
                       -FilterByRole SeedRing `
                       -FromDate $using:fromDate -ToDate $using:toDate } 

if($s)
{
    Remove-PSSession $s
}




$result[0] -match ".*\\(AzurestackLogs-.*)\\.*"
$newdir = "SeedRing" #$matches[1]
$resultdir = $HLHLogPath + "\" + $matches[1]

Write-Host "Deleting previous logs" 
del -Recurse .\$newdir

write-Host "Extracting log archive in " $resultdir
Expand-Archive -path ($resultdir + "\SeedRing-*.zip") ($newdir + "\temp")

Write-Host "Copying test-azurestack logs " 
copy .\$newdir\temp\*\azureStack_validation* .\SeedRing

Write-Host "Deleting log acrhive " 
del -Recurse .\$newdir\temp

Write-Host "Test-AzureStack logs:"
dir .\$newdir\AzureStack_Validation*

