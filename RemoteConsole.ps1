param(
    [string]$IpAddress,
    [string]$UserName,
    [string]$Password
)

$secret = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secret

$sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck                 
Enter-PSSession -ComputerName $IpAddress -Credential $cred -UseSSL -SessionOption $sessionOptions