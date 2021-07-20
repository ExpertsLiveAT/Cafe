# PS ARM Intro

## Preview Blog Link

https://devblogs.microsoft.com/powershell/announcing-the-preview-of-psarm/





## Syntax Konzepte 

### Imperative Syntax ==> PowerShell

### Declarative Syntax ==> ARM

## Installation
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
find-module psarm -AllowPrerelease
install-module psarm -AllowPrerelease

## Inspection
[String]$modulePathDesk = (split-path (Get-Module psarm -ListAvailable).path) + '/Desktop'
[String]$modulePathCore = (split-path (Get-Module psarm -ListAvailable).path) + '/Core'
get-childitem $modulePathDesk
get-childitem $modulePathCore

# Usage

Import-Module psarm
Get-Command -Module psarm


## Declatation files like Powershell scripts (Param Block and Code with *** Arm *** in Front)

param (
    $vmsize = 'D2S',
     $vmNet = 'TestNet',
      $vmIp = '192.16.0.100'
    )
Arm {
    'somecode here and usage or parameters' + $vmsize
#    resource (concat $vmsize $vmIp '-subnet') -Provider Microsoft.Network -ApiVersion 2019-11-01 
    Resource (concat $vmIp '-subnet') -
}

# Linux vm Example

## von psarm.ps1 zum JSON Template
$linuxvmparamht = @{
    AdminUserName = 'elatadmin'
    AuthenticationType = 'password'
    AdminPasswordOrKey = '$0me$1ron3pwD'
    # $vmName = 'CafeVm1'
    # $vmSize = 'Standard_D3_v2'
    # $virtualNetworkName = 'CafevNet'
    # $subnetName = 'CafeSubnet'
    # $networkSecurityGroupName = 'CafeSecGroupNet-1'
    # $ubuntuOSVersion = '20.04-LTS',
    # $location = 'westeurope'
}

$publishht = @{
    Path = './linux-vm.psarm.ps1' 
    OutFile = './linuxvm.json'
    Parameters = $linuxvmparamht
    force = $true
}

Publish-PSArmTemplate @publishht

New-AzResourceGroupDeployment -ResourceGroupName 't-rg-ELATPsARM' -TemplateFile ./linuxvm.json -WhatIf

New-AzResourceGroupDeployment -ResourceGroupName 't-rg-ELATPsARM' -TemplateFile ./linuxvm.json
# Remove-AzResourceGroupDeployment -Name linuxvm -ResourceGroupName t-rg-ELATPsARM


# Andere Befehle aus PsArm

## ConvertFrom-ArmTemplate # FAIL ;-(
ConvertFrom-ArmTemplate -Uri 'https://github.com/github/azure-quickstart-templates/blob/master/101-simple-windows-vm/azuredeploy.json' |
    Convertto-Psarm -Outfile ./windowsvm.psarm.ps1 -force

## Befehle für die ARM Funktionsfähigkeit
New-PSArmOutput -Name 'Test' -Type 'myType' -Value 'Value0'|convertfrom-Json
New-PSArmDependsOn
New-PSArmEntry
New-PSArmFunctionCall
New-PSArmResource
New-PSArmSku

$scriptblock = {
    New-PSArmOutput -Name 'Test' -Type 'myType' -Value 'Value0'
}
New-PSArmTemplate -Body $scriptblock -Name 'TemplateName'|ConvertFrom-Json


