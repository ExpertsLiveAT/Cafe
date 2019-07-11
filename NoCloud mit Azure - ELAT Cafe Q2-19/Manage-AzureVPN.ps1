# Check Onprem environment
Get-NetIPConfiguration -InterfaceAlias Ethernet
Get-Netroute -InterfaceAlias Ethernet -AddressFamily IPv4 

# Check connection to AzureVM
#CMD SSH

# Connect to Cloudnative domain
# Appid Connection
import-module az.accounts
$appid = '--your-app-id'
$appkeyplain = Read-Host -Prompt 'AppKey'
$appkey = ConvertTo-SecureString $appkeyPlain -asplaintext -force
$subscriptionname = 'YourSubscriptionName'
$rgName = 'p-rg-network'
$tenantid = '--your-tenant-id--'
$appcred = New-object -TypeName pscredential -ArgumentList ($appid,$appkey)

# Connect to the Azure Subscription
Connect-AzAccount -Credential $appcred -Tenant $tenantid -ServicePrincipal -Subscription $Subscriptionname

# List existing Azure VNETs
Import-Module Az.Network
$vNetName = 'p-thegalaxy-vnet110'
$vnet = Get-AzVirtualNetwork -Name $vnetName
$vnet|Select-Object Name,AddressSpaceText,Subnets|Format-List

# SUBNETs auflisten
Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vNet|select-object Name,AddressPrefix

# Ein Azure Gateway erzeugen
$vnetGatewayName = 'p-thegalaxy-vngateway'
Get-AzVirtualNetworkGateway -ResourceGroupName $rgName -Name $vnetGatewayName|Select-Object Name, GatewayType, VPNType
# New-AzVirtualNetworkGateway


# Public IP
$pubipname = 'p-thegalaxy-ipsecpublic'
Get-AzPublicIpAddress -ResourceGroupName $rgName -Name $pubipname|select-object Name,PublicIPAllocationMethod,IPAddress

# Local Network Gateway
$locNetGWName = 'p-thegalaxy-hydra'
Get-AzLocalNetworkGateway -Name $locNetGWName -ResourceGroupName $rgName |select-object Name,GatewayIpAddress -expandproperty LocalNetworkAddressSpace

# FORTIGATE TEIL

# Azure Site2Site Gateway einrichten
$vpnConnName = 'p-site2site-hydra'
Get-AzVirtualNetworkGatewayConnection -ResourceGroupName $rgName -Name $vpnConnName|select-object Name,Connectionstatus,VirtualNetworkGateway1Text,LocalNetworkGateway2Text|format-List

# DONE!
