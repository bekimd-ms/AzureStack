$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 30
$targetratio = (get-random -min 2 -max 8)/10
Write-Host "Target ratio ", $targetratio

function GetFreeRatio
{
  $volume = get-volume -DriveLetter F
  $ratio = $volume.SizeRemaining / $volume.Size 
  $ratio
}

function GenerateContent
{

   $content = -join(Get-Random $chars -Count 512)

   for($i=1; $i -lt 512; $i++)
   {
      $content = -join($content, -join( Get-Random $chars -Count 512))
   }

   $content
}

$content = GenerateContent
while( (GetFreeRatio) -gt $targetratio )
{

  $order = get-random -min 3 -max 5
  $min = [math]::pow(10,$order)
  $max = [math]::pow(10,$order+1)
  $cnt = get-random -min $min -max $max
  $cnt = [math]::round($cnt)

  $folder = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

  mkdir $folder

  for ($i=1; $i -lt $cnt; $i++) 
  {     
     $file = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

     $file = $folder + "/" + $file

     $size = (get-random -min 10 -max 1000)
     $sizegb = ($size * $content.Length)/(1024*1024*1024)
     Write-Host $sizegb, $file

     for($i=1; $i -lt $size; $i++)
     {
        $content | Out-file -FilePath $file -Append
     }

  }

}




