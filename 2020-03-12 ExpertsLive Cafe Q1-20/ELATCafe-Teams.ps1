# Vorbereitungen 
## Welche Teams Module gibts auf der PowerShell Gallery ?
find-module '*Teams*' |select Name,CompanyName,Version,Description,PublishedDate,UpdatedDate,ProjectUri|ogv
## oder unter Einbindung von Downloads
find-module '*Teams*' |foreach {"$(($_.AdditionalMetadata).DownloadCount) downloads von $($_.Name)"}

## Wir entscheiden uns für MicrosoftTeams und PSTeams
Install-Module PSTeams,MicrosoftTeams -Scope CurrentUser -WhatIf

## Laden des Moduls
Import-Module MicrosoftTeams

# Administrieren von Teams
## Verbinden (TenantID Optional)
Connect-MicrosoftTeams -TenantId '00000000-aaaa-bbbb-cccc-dddddddddddd'

## Welche Teams gibt es ?
Get-Team |select DisplayName,GroupID|Tee-Object -Variable Teams

## Channel eines Teams herausfinden
($teams.Where{$_.DisplayName -like 'Cafes'}).GroupId

Get-TeamChannel -GroupId (($teams.Where{$_.DisplayName -like 'Cafes'}).GroupId) `
    |set-Variable CafeChannel

Get-TeamChannel -GroupId (($teams.Where{$_.DisplayName -like 'Cafes'}).GroupId) `
    |Tee-Object -Variable CafeChannel


## User eines Teams herausfinden
Get-TeamUser -GroupId ($teams.Where{$_.DisplayName -like 'Cafes'}).GroupId|Tee-Object -Variable CafeUsers

# Neues Teams-team erstellen
$NewTeamHT = @{
    DisplayName = 'ELATCafe-Wien'
    Visibility = 'Public'
    Description = 'ELAT Cafe 03-2020 Wien'
    }
New-Team @NewTeamHT|Tee-Object -Variable DemoTeam

## FYI: Teams legt immer den "Allgemein" Channel dazu an.

## Weiteren Channel einrichten
New-TeamChannel -GroupId $DemoTeam.GroupId -DisplayName JokeOfTheDay -Description 'Witz des Tages'|Tee-Object -Variable DemoChannel

## Incoming Webhook connector erzeugen (MANUELL)
$WEBHookUri = 'https://outlook.office.com/webhook/8Kopiere_den_Webhook_von_der_Teams_Konfig_hier_herein'



## User hinzufügen
Add-TeamUser -GroupId $DemoTeam.GroupId  -User '2b489c5d-2e8e-43b2-b946-14c55937064c'
Get-TeamUser -GroupId $DemoTeam.GroupId

## Teams entfernen (dauert etwas ...)
## Remove-Team -GroupId 'a538b898-a602-486a-99d1-03cb38035852'


# Und jetzt Daten einfügen

##Öffentliche Chuck Norris Witzedatenbank.
function get-joke {
    $params = @{
        uri =  'https://geek-jokes.sameerkumar.website/api'
        headers = @{'content-type'= 'application/json'}
        Method = 'GET'
        }
    
    $geekjoke = Invoke-RestMethod @params
    return $geekjoke
}
get-joke|tee-object -Variable witz

## 3rd Party Modul PSTeams laden 
Import-Module PSTeams

## Einfache Nachricht senden
Send-TeamsMessage -MessageTitle (Get-Joke) -Uri $WEBHookUri
1..5 |foreach-object {Send-TeamsMessage -MessageTitle (Get-Joke) -Uri $WEBHookUri; start-sleep -Seconds 1}

## Komplexere Nachrichten aufbauen und senden

### Was kann man alles senden ?
$GenButtonDefault = New-TeamsButton -Name 'ELAT Homepage' -Link 'https://www.expertslive.at' 
$GenButtonOpenUri = New-TeamsButton -Type OpenUri -Name 'URI Öffnen' -Link 'https://www.expertslive.at' 
$GenButtonDateInput = New-TeamsButton -Type DateInput -Name 'Datum eingeben'  -Link 'https://www.expertslive.at' 
$GenButtonOpenhttpPost = New-TeamsButton -Type HttpPost -Name HTTPPost  -Link 'https://www.expertslive.at' 
$GenButtonTextInput = New-TeamsButton -Type TextInput -Name 'TextInput'  -Link 'https://www.expertslive.at' 
$GetFact = New-TeamsFact -Name 'Fette Überschrift **' -Value '**Da kann man was reinschreiben**'

$GenMessage = New-TeamsSection `
-ActivityTitle 'ActivityTitle' `
-ActivitySubtitle 'ActivitySubtitle' `
-ActivityImageLink "https://www.powershell.co.at/wp-content/uploads/2020/03/sea-flight-sky-earth-2163-e1583580034276.jpg" `
-ActivityText 'ActivityText' `
-ActivityDetails $GenFact `
-Buttons $GenButtonDefault, $GenButtonOpenUri, $GenButtonTextInput, $GenButtonOpenhttpPost , $GenButtonDateInput

Send-TeamsMessage -MessageTitle "Generischer Post" -MessageSummary 'Was geht ..' -Uri $WEBHookUri -Sections $GenMessage -Color 'Green'

### Veranstaltungs Info
$Color = 'BlueViolet'
$Button1 = New-TeamsButton -Name 'PS7 Launch Event Info' -Link "https://www.powershell.co.at/events/powershell-7-launch-event-austria/"
$Button2 = New-TeamsButton -Name 'Anmeldelink auf XING' -Link "https://www.xing.com/events/powershell-7-launch-osterreich-2792996?activation"
$Fact1 = New-TeamsFact -Name 'Fette Überschrift **' -Value '**DER PS7 Launch Event in Österreich**'
$Fact2 = New-TeamsFact -Name 'Kursiv/Fetter Sub ***' -Value '***Alle 3 PowerShell MVP´s in Österreich Vorort***'
$Fact3 = New-TeamsFact -Name 'Kursives Datum *' -Value 'Am *30. März 2020*'
$Fact4 = New-TeamsFact -Name 'Agenda (DRAFT)' -Value "
* 17:30 – 18:00 Eintreffen
* 18:00 – 18:10 Willkommen und Intro
* 18:10 – 18:40 Neue Features die es bei PowerShell noch nie gab!
* 18:40 – 19:30 PowerShell 7 für die tägliche Windows Administration – Möglichkeiten und Grenzen.
* 
* 19:30 – 19:40 Pause
* 19:40 – 20:00 PS 5.1 und PS 7 side-by-side Installation. worauf muss man achten?
* 20:00 – 20:30 Q&A an das PowerShell Engineering Team
* 
* 20:30 – 21:30 Networking bei Getränken und Brötchen"

$PS7Launch = New-TeamsSection `
-ActivityTitle '**DER PS7 Launch Event in Österreich**' `
-ActivitySubtitle '*Alle Infos zur neuen Version*' `
-ActivityImageLink "https://www.powershell.co.at/wp-content/uploads/2020/03/sea-flight-sky-earth-2163-e1583580034276.jpg" `
-ActivityText 'Teams Live-Stream' `
-Buttons $Button1, $Button2 `
-ActivityDetails $Fact4

Send-TeamsMessage -MessageTitle "PS7 Launch" -MessageSummary 'Ankündigung mit allen Details' -Uri $WEBHookUri -Sections $PS7Launch -Color $color

### *** Viel Spass beim experimentieren *** ###