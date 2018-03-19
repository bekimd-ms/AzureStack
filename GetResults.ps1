Param(
  [string]$FileName="",
  [string]$TestName=""
)
$json = get-content -Path $file | ConvertFrom-Json 

if( $TestName -eq "" )
{
  $json.Information | sort group, name | select group, name, desc
}
else
{
  $testlist = $json.Information | where Name -like $TestName 

  $rootobj = new-object psobject 
  $cnt = 1
  
  foreach( $test in $testlist )
  {
    Write-Host $cnt " " $test.Name $test.Desc $test.Fields.Count " fields and " $test.Data.Count " items"
    $cnt += 1
    if( -not ([string]::IsNullOrEmpty($test.Name)) -and $test.Data.Count -lt 10000 )
    { 
        $obj = new-object psobject 
        $obj | Add-Member -Name Name -Value $test.Name -MemberType NoteProperty
        $obj | Add-Member -Name Desc -Value $test.Desc -MemberType NoteProperty 
        $obj | Add-Member -Name Group -Value $test.Group -MemberType NoteProperty 
        $obj | Add-Member -Name Data -Value @() -MemberType NoteProperty 

        $props = @()
        foreach( $field in $test.Fields )
        { 
          $props += @(($field.Disp -replace ' ', '' -replace '\?', ''  -replace '\(','' -replace '\)',''))
        }

        foreach( $data in $test.Data )
        {
          $dataobj = new-object psobject 
          for( $i=0; $i -lt $props.Count; $i++ )
          { 
              $propName = $props[$i]
              $dataobj | Add-Member -Name $props[$i] -Value $data[$i] -MemberType NoteProperty
          }
          $obj.Data += @( $dataobj )
        }
        $propName = $obj.Name -replace ' ','' -replace '\(','' -replace '\)',''
        $rootobj | Add-Member -Name $propName -Value $Obj -MemberType NoteProperty
    }

  }
  $rootobj
}