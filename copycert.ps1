$label="AzureStackSelfSignedRootCert"
Write-Host "Getting certificate from the current user trusted store with subject CN=$label"
$root=Get-ChildItem Cert:\CurrentUser\Root | Where-Object Subject -eq "CN=$label" | select -First 1
if(-not$root)
{
   Log-Error "Cerficate with subject CN=$label not found"
   return
}
 
Write-Host "Exporting certificate"
Export-Certificate -Type CERT -FilePath root.cer -Cert $root
 
Write-Host "Converting certificate to PEM format"
certutil -encode root.cer root.pem
 
Write-Host "Extracting needed information from the cert file"
$md5Hash=(Get-FileHash -Path root.pem -Algorithm MD5).Hash.ToLower()
$sha1Hash=(Get-FileHash -Path root.pem -Algorithm SHA1).Hash.ToLower()
$sha256Hash=(Get-FileHash -Path root.pem -Algorithm SHA256).Hash.ToLower()
 
$issuerEntry=[string]::Format("# Issuer: {0}",$root.Issuer)
$subjectEntry=[string]::Format("# Subject: {0}",$root.Subject)
$labelEntry=[string]::Format("# Label: {0}",$label)
$serialEntry=[string]::Format("# Serial: {0}",$root.GetSerialNumberString().ToLower())
$md5Entry=[string]::Format("# MD5 Fingerprint: {0}",$md5Hash)
$sha1Entry =[string]::Format("# SHA1 Finterprint: {0}",$sha1Hash)
$sha256Entry=[string]::Format("# SHA256 Fingerprint: {0}",$sha256Hash)
$certText=(Get-Content -Path root.pem -Raw).ToString().Replace("`r`n","`n")
 
$pythonCertStore="${env:ProgramFiles(x86)}\Python35\Lib\site-packages\certifi\cacert.pem"
 
$rootCertEntry="`n"+$issuerEntry+"`n"+$subjectEntry+"`n"+$labelEntry+ `
               "`n"+$serialEntry+"`n"+$md5Entry+"`n"+$sha1Entry+"`n"+$sha256Entry+"`n"+$certText
 
Write-Host "Adding the certificate content to python cert store"
Add-Content "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certifi\cacert.pem" $rootCertEntry
Write-Host "Python Cert store got updated for aloowing the azure stack CA root certificate"
