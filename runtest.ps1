write-Host "Creating pool" 
.\createpool.ps1
Write-Host "Pool created" 
copy generatedirs.ps1 f:\
cd F:\
F:
Write-Host "Starting disk write" 
Start-Process Powershell ./generatedirs.ps1