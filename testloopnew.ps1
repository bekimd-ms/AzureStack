Param(
  [string]$location = "",
  [string]$dns = "",
  [string]$sub = "", 
  [string]$user = "",
  [string]$pwd = "",
  [string]$maxvm=2,
  [string]$vmcount=4,
  [string]$vnet = "",
  [string]$vnetrg = "",
  [string]$sleeptime = 10
)

function CreateNewVnet
{
    $rgname = " -rgname '" + $size + "vm" + (-join(Get-Random $chars -Count 8)) + "' " 
    $command = $commandprefix + $rgname + ( GetCommand $size )
    Write-Host "Starting Public VM in new vnet : " $size ": " $command  
    #$processes += @(Start-Process -PassThru Powershell "$command")    
}

function CreateVMinVnet
{
    $rgname = " -rgname '" + $size + "vm" + (-join(Get-Random $chars -Count 8)) + "' " 
    $command = $commandprefix + $rgname + ( GetCommand $size )
    Write-Host "Starting Private VM in vnet : "  $size  ": " $command 
    #$processes += @(Start-Process -PassThru PowerShell ./testcnt.ps1)
    #$processes += @(Start-Process -PassThru Powershell "$command")
}


$commandprefix = "./tools/logindeployvm.ps1 -location " + $location + " -dns " + $dns + " -sub " + $sub + `
                 " -user " + $user + " -pwd " + $pwd + " -vnetrg " + $vnetrg + " -vnet " + $vnet 
                
Write-Host "Command " $commandprefix

$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 3

$sizes = @("xxl") * 2
$sizes = $sizes + (@("xl") * 4 )
$sizes = $sizes + (@("l") * 8 )
$sizes = $sizes + (@("m") * 16 )
$sizes = $sizes + (@("s") * 32 )
$sizes = $sizes + (@("xs") * 38 )

$sizes = $sizes | sort {get-random }

function GetCommand( $size )
{
   switch( $size ) 
   {
      "xxl" { "-vmsize Standard_D4 -disknum 4 -disksize 1023" } 
      "xl"  { "-vmsize Standard_D3 -disknum 2 -disksize 1023" }
      "l"   { "-vmsize Standard_D2 -disknum 1 -disksize 1023" }
      "m"   { "-vmsize Standard_D1 -disknum 1 -disksize 511" }
      "s"   { "-vmsize Standard_D1 -disknum 1 -disksize 127" }
      "xs"  { "-vmsize Standard_D1 -disknum 0 -disksize 0" }
   }

}

$nextvm = 0
$activevm = 0
$vnets = @()
$vnetsvmcount = @()

while( $nextvm -lt $vmcount )
{
   Write-Host "Active deployments ", $activevm 
   Write-Host "Next VM            ", $nextvm 
   if( $activevm -lt $maxvm ) 
   {
   	$size = $sizes[$nextvm]  
   	$nextvm = $nextvm + 1
        
	
   }
   
   $liveproc = 0	   
   Write-Host "Checking processes..." 
   foreach( $process in $processes )  
   {
      if( -not $process.HasExited ) 
      {
        $liveproc = $liveproc + 1 
      }
   }
   $activevm = $liveproc 

   start-sleep -s $sleeptime
}

# vnets 
#   name 
#   vmcount 
# vnetcnt

# loop 
#   if( vnetcnt < 4 ) { vnet += @( CreatePubVMandVnet ) vnetcnt++ }
#   vnet = choose vnet
#   if( vnet )
#   {
#       vnet.AddVM()
#       vnet.vmcount ++  
#       if( vnet.vmcount > maxvminvnet ) { vnet.disable; vnetcnt-- } 
#   } 

