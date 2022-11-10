# Aktueller Stand PSG Version 2x
# Gitbuh REPO: https://github.com/PowerShell/PowerShellGetv2
Get-Module powershellget -ListAvailable |select-Object version,Path

# 2.x sehr chaotisch. 
# In Windows 1.0.0.1, 2.2.4 und 2.2.5 benötigt, dann nicht mehr weiterentwickelt
# Siehe Excel

# Sammeln wir die Befehle von 2.x
Import-Module powershellget -RequiredVersion 2.2.5
$cmdsv2 = get-command -Module powershellget
Remove-Module PowerShellget -Force

# 3.0 RC10 installieren # Version 3.0.17-beta17
# Github: https://github.com/PowerShell/PowerShellGet
<# ReleaseBlogs
3.0.17 https://devblogs.microsoft.com/powershell/powershellget-3-0-preview-17/
3.0.16 https://devblogs.microsoft.com/powershell/powershellget-3-0-preview-16/
3.0.14 https://devblogs.microsoft.com/powershell/powershellget-3-0-preview-14/
#>

Install-Module PowershellGet -AllowPrerelease -Force
# Force, damit 2.2.5 parallel laufen kann

Import-Module PowerShellGet -RequiredVersion '3.0.17'
Update-Module PackageManagement ## Fehler ;-(
Install-Module PackageManagement -Force

# BINARY Module, sieht man an den Befehlen
get-command -Module PowerShellGet -CommandType CmdLet
$cmdsv3 = get-command -Module powershellget

# Vergleich der Befehle
$cmdsv2.count
$cmdsv3.count
$cmdsv2.count - $cmdsv3.count

# Unterschiede in den Befehlen
$cmdsv3|group-object noun

## Repositories heißen jetzt PSResourceRepositories
$cmdsv3|where-object noun -EQ 'PSResourceRepository'

## Scripts und Module heißen jetzt PSResource
$cmdsv3 
#|where-object noun -eq 'PSResoure'

## Der Rest
$cmdsv3|where-object Name -notlike '*PSResource*'


# Arbeiten mit Resourcerepositories

## Repo Trusten (PSGallery ist default gelistet)
Get-PSResourceRepository
Set-PSResourceRepository -Name PSGallery -Trusted # Weitere Parameter Credential/Prio

## Weiteres Repo registrieren und deregistrieren mit (un)Register-PSResourceRepository
## Hilfe hierzu: https://github.com/PowerShell/PowerShellGet/blob/master/help/Register-PSResourceRepository.md
## Repo erzeugen: https://powershellexplained.com/2017-05-30-Powershell-your-first-PSScript-repository/

#Update eines Moduls - Handling von alten Modulen
Find-PSResource Az.Accounts
Find-PSResource Az*
Find-PSResource Az.Accounts -Version *
(Find-PSResource Az.Accounts -Version *).Count
Get-Module Az.Accounts -Listavailable
Update-PSResource Az.Accounts
Get-Module Az.Accounts -Listavailable

# Management aller Ressourcen die lokal installiert sind (weg von Get-Module)
Get-PSResource
Get-PSResource *Accounts*
Get-PSResource Az.Accounts -Version "(2.7.6, 2.10.3.0)" # Within range
# Achtung bei Previews/Betas
Get-PSResource PowerShellGet -Version 3.0.17-beta17 # Show
Get-PSResource PowerShellGet -Version 3.0.17 # NoShow

# Neue Software herunterladen und managen
Save-PSResource Az.Accounts -Path /Users/roman/temp
Install-PSResource PSWriteExcel

# Deinstallieren

Install-PSResource Az.Accounts -Version "(2.9.0, 2.10.2.0)" -verbose
Get-PSResource Az.Accounts -Version "(2.9.0, 2.10.2.0)" -verbose
UnInstall-PSResource Az.Accounts -Version "(2.9.0, 2.10.2.0)" -SkipDependencyCheck -verbose
# Unbekanntere Befehle ...

## Wenn wir ein Script Publishen wollen:
New-PSScriptFileInfo test.ps1 -Description 'PowerShell UserGroup Austria'
## More details here:https://github.com/PowerShell/PowerShellGet/blob/master/help/New-PSScriptFileInfo.md

Test-PSScriptFileInfo test.ps1
Update-PSScriptFileInfo test.ps1 -CompanyName PowerShellUserGroupAustria

## Wenn wir ein Modul publishen wollen
Update-ModuleManifest testmod.ps1 -CompanyName ## testmod1.psd1 ist nicht vorhanden...
## Mehr hier: https://github.com/PowerShell/PowerShellGet/blob/master/help/Update-ModuleManifest.md

<# Publizieren
Publish-PSResource -
-apiKey 'yourapikey'
-Repository 'PSGallery'
-Path 'dortwodieressourceliegt (script/Modul)'
#>

## !!! Saubere 2.2.5 installation
## PowerShellGet 3.0.17 hat noch bugs, z.B. 
## https://github.com/PowerShell/PowerShellGet/issues/835

