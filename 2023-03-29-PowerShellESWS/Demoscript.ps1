# Authentifizieren
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All" -UseDeviceAuthentication

# Script ausführen - Scope erkennen
./MyMGUser.ps1
Get-Command -Verb New -Noun MyMGUser

# Geladen mit DOT Sourcing
. ./MyMGUser.ps1
Get-Command -Verb New -Noun MyMGUser

New-MYMGUser -DisplayName 'User 1' -UserPrincipalName 'u1@rconsult.at' -MailNickName 'u1'

# Transformation zu einem MODUL
Import-Module ./00-module.psm1
Get-Command -Verb New -Noun MyMGUser

New-MYMGUser -DisplayName 'User 2' -UserPrincipalName 'u2@rconsult.at' -MailNickName 'u2'
Remove-MyMgUser -userPrincipalName 'u2@rconsult.at'

Remove-Module 00-module -Force
Get-Command -Verb New -Noun MyMGUser

# Hinzufügen von [CmdLetBinding()]
# Variable $PSCmdLet verfügbar
# $PsCmdLet.SupportsShouldProcess

# EXKURS [CmdLetBinding()]

# LADE 01-Modul

Import-Module ./01-module.psm1
New-MYMGUser -DisplayName 'User 3' -UserPrincipalName 'u3@rconsult.at' -MailNickName 'u3' -WhatIf

New-MyMGUser
Remove-MyMgUser

## Verpflichtende Parameter

# LADE 02-Module

ipmo ./02-module.psm1

New-MyMGUser
Remove-MyMGUser

New-MyMGUser -UserPrincipalName 'ulp@rconsult.at' -displayName 'User Low Pwd' -mailNickName 'ulp' -password 'abc123'

## Passwortstärke ;-((

ipmo ./02-module.psm1 -Force
New-MyMGUser -UserPrincipalName 'ulp@rconsult.at' -displayName 'User Low Pwd' -mailNickName 'ulp' -password 'abc123'

New-MyMGUser -UserPrincipalName 'ucp@rconsult.at' -displayName 'User Complex Pwd' -mailNickName 'ucp' -password '$1&34_ABC_hbg'

Remove-MyMGUser -userPrincipalName 'ucp@rconsult.at'

## Erweitern um gewisse Länder

# LOAD 03-Module

ipmo ./03-module.psm1

New-MyMGUser -UserPrincipalName 'ucp@rconsult.at' -displayName 'User Complex Pwd' -mailNickName 'ucp' -password '$1&34_ABC_hbg' -Country

## Erweitern um ein Validierunsscript für Remove-mymguser

ipmo ./04-module.psm1

Remove-mymguser -userPrincipalName 'notexist@rconsult.at'

## Erweitern um eine Personalnummer zwischen 10000 und 99999

new-mymgUser -DisplayName 'User 5' -UserPrincipalName 'user5@rconsult.at' -mailNickName 'u5' -EmployeeID 50000

# Erlauben von Massenimports

ipmo ./06-module.psm1

Import-csv ./Users.csv|New-MyMGUser -whatif

Import-csv ./users.csv| foreach-object { Remove-MyMgUser -userPrincipalName $_.UserPrincipalName -whatif}
Import-csv ./users.csv| foreach-object { Remove-MyMgUser -userPrincipalName $_.UserPrincipalName -Confirm:$false}

# Erstellen eines Modul manifests

New-ModuleManifest -Path ./MyMGModule/MyMgModule.psd1







