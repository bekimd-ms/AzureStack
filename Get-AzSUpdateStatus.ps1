#1. Send email notification with attachment of CSV file (showing all upgrade activities status and time) in every 3 hours 

#2. Send email notification immediately when the upgrade activity hit “error” or “failed” status
<#
Cusotmer need modify info below:
$To = "To-Email-Address"
$CC = "CC-Email-Address"
$SmtpServer = "smtp.gmail.com"
$From = "From-Email-Address"
$port = 587
$ERCS = "xxx.xxx.xx.224"
After customer exports the credential. Customer can remove the first 6 line of the script. Customer can also modify as needed. 
#>


$UserName = "From-Email-Address"
$pwd = ConvertTo-SecureString "xxx" -AsPlainText -Force
New-Object System.Management.Automation.PSCredential($UserName, $pwd)  | Export-Clixml "C:\temp\FromEmail.xml"
$CloudAdminName = "DomainName\xxx"
$pwd= ConvertTo-SecureString "xxx" -AsPlainText -Force
New-Object System.Management.Automation.PSCredential($CloudAdminName, $pwd)  | Export-Clixml "C:\Temp\Cloudadmin.xml"



$CloudAdminCred = Import-Clixml "C:\Temp\Cloudadmin.xml"
$Cred = Import-Clixml "C:\temp\FromEmail.xml"


#$cred = Get-Credential
$To = "To-Email-Address"
$CC = "CC-Email-Address"
$SmtpServer = "smtp.xxx.com"
$From = "From-Email-Address"
$port = 587
$ERCS = "xxx.xxx.xx.xxx"


$updatestatus = Invoke-Command $ERCS -Credential $CloudAdminCred -ConfigurationName PrivilegedEndpoint -ScriptBlock { Get-AzureStackUpdateStatus -statusonly} 
$updatestatus.value

while ($updatestatus.Value -eq "Failed")
{
    $Verboselog = Invoke-Command $ERCS -Credential $CloudAdminCred -ConfigurationName PrivilegedEndpoint -ScriptBlock { Get-AzureStackUpdateVerboseLog} 
    $Verboselog > C:\temp\AzSUpdateVerboselog.txt
    Send-MailMessage `
    -To $To `
    -CC $CC `
    -Subject "Alert. Update is failed." `
    -Body "Update is failed. Attached update verbose log for you, please contact support for help" `
    -SmtpServer $SmtpServer `
    -From $From `
    -Port $port `
    -UseSsl `
    -Credential  $Cred   `
    -Attachments "C:\temp\AzSUpdateVerboselog.txt"
}

If($updatestatus.Value -eq "Running")
{
    $time = Get-Date -format yyyy_MM_ddTHH_mm_ss
    [xml]$statusString = Invoke-Command $ERCS -Credential $CloudAdminCred -ConfigurationName PrivilegedEndpoint -ScriptBlock { Get-AzureStackUpdateStatus } 
    #$statusString.SelectNodes("//Step[@Status='InProgress']") | Export-Csv C:\temp\AzSUpdateStatus$time.CSV
    $statusString.SelectNodes("//Step") | Export-Csv C:\temp\AzSUpdateStatus$time.CSV
            Send-MailMessage `
            -To $To `
            -CC $CC `
            -Subject "Update is still Running" `
            -Body "Update is still Running" `
            -SmtpServer $SmtpServer `
            -From $From `
            -Port $port `
            -UseSsl `
            -Credential $Cred   `
            -Attachments "C:\tem\AzSUpdateStatus$time.CSV"
}
    elseif ($updatestatus.Value -eq "Completed")
{
    Send-MailMessage `
    -To $To `
    -CC $CC `
    -Subject "Update is Completed." `
    -Body "Please double confirm Stamp status from Admin Portal" `
    -SmtpServer $SmtpServer `
    -From $From `
    -Port $port `
    -UseSsl `
    -Credential  $Cred  
} else
{
    Send-MailMessage `
    -To $To `
    -CC $CC `
    -Subject "Something unexpected occurred during AzS upgrade, please check. " `
    -Body "Please check Stamp status from Admin Portal" `
    -SmtpServer $SmtpServer `
    -From $From `
    -Port $port `
    -UseSsl `
    -Credential  $Cred  
}
