$resourceGroupName = "controlvm"
$sourceVhd = "E:\Azure backups\AcmeSrv-AcmeSrv-2014-11-23.vhd"
$destinationVhd = "https://images.blob.redmond.azurestack.corp.microsoft.com/vhds1/ubvm1osdisk.vhd"
 
Add-AzureRmVhd -LocalFilePath $sourceVHD -Destination $destinationVHD `
               -ResourceGroupName $resourceGroupName -NumberOfUploaderThreads 5

$virtualNetworkName = "controlvm-vnet"
$locationName = "local"
$virtualNetwork = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName `
                                            -Name $virtualNetworkName


$publicIp = New-AzureRmPublicIpAddress -Name "winvm1-ip" -ResourceGroupName $ResourceGroupName `
                                       -Location $locationName -AllocationMethod Dynamic

$networkInterface = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName `
     -Name "winvm1-ni" -Location $locationName -SubnetId $virtualNetwork.Subnets[0].Id `
     -PublicIpAddressId $publicIp.Id

$vmConfig = New-AzureRmVMConfig -VMName "winvm1" -VMSize "Standard_DS1"
$vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name "winvm1" -VhdUri $destinationVhd `
                                -CreateOption Attach -Windows
$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $networkInterface.Id

$vm = New-AzureRmVM -VM $vmConfig -Location $locationName -ResourceGroupName $resourceGroupName
