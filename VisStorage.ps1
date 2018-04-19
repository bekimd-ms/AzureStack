Param(
  [string]$InputJsonFileName="",
  [string]$OutputJsonFileName=""
)

function GetTestObject( $test )
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
          $dataobj | Add-Member -Name $props[$i] -Value $data[$i] -MemberType NoteProperty
      }
      $obj.Data += @( $dataobj )
    }

    $obj
}


# load the test sections
$json = get-content -Path $InputJsonFileName | ConvertFrom-Json

$tests = @( [pscustomobject]@{PropName="Hosts"; Name="Infrastructure Hosts"},
            [pscustomobject]@{PropName="PDisks"; Name="Storage Spaces Direct Physical Disks" },
            [pscustomobject]@{PropName="Summary"; Name="Storage Services Summary" } )
            
$list = new-object psobject 
$root = new-object psobject

# parse sections into objects 
foreach( $test in $tests )
{
    $result = $json.Information | where Name -eq $test.Name
    $result = (GetTestObject( $result )).Data
    $list | Add-Member -Name $test.PropName -Value $result -MemberType NoteProperty
}

# filter and sort the required objects 
$hosts      = $list.Hosts | where InfrastructureType -eq "Host Cluster Nodes" | sort Name
$hoststate  = $list.Hosts | where InfrastructureType -eq "Host Cluster Node State" | sort Name

$root | Add-Member -Name Host -Value $hosts -MemberType NoteProperty

$networks   = $list.Hosts | where InfrastructureType -eq "Host Cluster Network" | sort Name
$root | Add-Member -Name Network   -Value $networks -MemberType NoteProperty

$fileserver = $list.Hosts | where InfrastructureType -eq "Host Cluster File Server" | sort Name
$root | Add-Member -Name Fileserver -Value $fileserver -MemberType NoteProperty

$cluster    = $list.Hosts | where InfrastructureType -eq "Host Cluster" | sort Name
$root | Add-Member -Name Cluster    -Value $cluster -MemberType NoteProperty

# group the volumes
$volumes = $list.Summary | where FileShare -ne "SU1_Public" |  select @{Expression={$_.VirtualDisk.Substring(0,3)};Label="Type"}, * `
                         | sort VolumeName | group OwnerNode | sort Name

# group the physical disks
foreach( $pdisk in $list.PDisks )
{
    $m = $pdisk.Host -match "(.*)\..*\..*"
    $pdisk.Host = $matches[1]
}
$pdisks = $list.PDisks | sort Host, SlotNumber | group Host | sort Name

foreach( $hostx in $root.Host )
{
    $temp = $hoststate | where Name -eq $hostx.Name 
    $hostx | Add-Member -Name OperationalStatus -Value $temp.State -MemberType NoteProperty

    $hostvol = ($volumes | where Name -eq $hostx.Name  ).Group | Group Type | sort Name 
    $hostx | Add-Member -Name Infra -Value $hostvol[0].Group -MemberType NoteProperty 
    $hostx | Add-Member -Name Object -Value $hostvol[1].Group -MemberType NoteProperty
    $hostx | Add-Member -Name Temp -Value $hostvol[2].Group -MemberType NoteProperty 

    $hostdisk = ($pdisks | where Name -eq $hostx.Name ).Group | Group BusType | sort Name 
    $hostx | Add-Member -Name Capacity -Value $hostdisk[1].Group -MemberType NoteProperty
    $hostx | Add-Member -Name Journal -Value $hostdisk[0].Group -MemberType NoteProperty
}


$root | ConvertTo-Json -Depth 10 | out-file $OutputJsonFileName 