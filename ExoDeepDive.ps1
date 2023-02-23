# Messaget tracing with PowerSHell

# Info hier: https://learn.microsoft.com/en-us/exchange/monitoring/trace-an-email-message/message-trace-faq

Get-MessageTrace
Get-MessageTrace -StartDate 13.2.2023 -Enddate 23.2.2023
Get-MessageTrace -StartDate 1.1.2023 -Enddate 31.1.2023

# For older searches you need to run a search JOB
$HistsearchJob = @{
    StartDate = '01/01/2023'
    EndDate = '01/31/2023'
    ReportTitle = 'ElatCafeHistJob'
    ReportType = 'MessageTrace'
    NotifyAddress = 'rs@rconsult.at'
    recipient = 'seppmail@seppmail.at'
}

Start-HistoricalSearch @HistSearchJob 
Get-HistoricalSearch

# OUTBOUND !

## Send E-Mail to info@powershell.co.at (Outbound !)

## Trace in Portal

## Trace in PowerShell
$RA = 'info@powershell.co.at'
get-messagetrace -RecipientAddress $ra
get-messagetrace -RecipientAddress $ra|Select-Object -first 1

## Whats in the full trace ?
get-messagetrace -RecipientAddress $Ra|Select-Object -first 1|select Subject,Messageid,MessageTraceId

## What hapens to the E-Mail to other recipients and whats the ID´s ?
get-messagetrace -RecipientAddress 'rs@expertslive.at'|Select-Object -first 1|select Subject,Messageid,MessageTraceId

## Get the messagetraceID and MessagetraceDetail Infos
$MTid = (get-messagetrace -RecipientAddress $RA|Select-Object -first 1).MessagetraceID
$mtd = Get-MessageTraceDetail -MessageTraceId $MTID -RecipientAddress $ra

## What happens first ?
$mtd
$mtd|sort-object -Property Date
foreach ($i in $mtd) {$i| Foreach-object {"Message Event $($_.Event) happens at " + "{0:hh}:{0:mm}:{0:ss}:{0:ffff}" -f $_.Date}}

# Transport-Time
(New-Timespan -Start ($mtd.Where({$_.Event -like 'Empfangen'})).Date -End ($mtd.Where({$_.Event -like 'Übermitteln'})).Date).TotalMilliseconds
(New-Timespan -Start ($mtd.Where({$_.Event -like 'Übermitteln'})).Date -End ($mtd.Where({$_.Event -like 'Extern senden'})).Date).TotalMilliseconds
## Total transport Time
(New-Timespan -Start ($mtd.Where({$_.Event -like 'Empfangen'})).Date -End ($mtd.Where({$_.Event -like 'Extern senden'})).Date).TotalMilliseconds

## Interessanting commons

## Empty or useless properties
$mtd.Where({$_.Event -like 'Empfangen'})|Select-object Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$mtd.Where({$_.Event -like 'Übermitteln'})|Select-object Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$mtd.Where({$_.Event -like 'Extern senden'})|Select-object Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate

# And what about transport rules ?
$mtd.Where({$_.Event -like 'Transportregel'})|Select-object Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate

## Value properties
$mtd.Where({$_.Event -like 'Empfangen'})|Select-object -ExcludeProperty Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$mtd.Where({$_.Event -like 'Übermitteln'})|Select-object -ExcludeProperty Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$mtd.Where({$_.Event -like 'Extern senden'})|Select-object -ExcludeProperty Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate


## Content of the 3 TraceDetail messages.
$recMTD = $mtd.Where({$_.'Event' -like 'Empfangen'})
$subMTD = $mtd.Where({$_.'Event' -like 'Übermitteln'})
$sndMTD = $mtd.Where({$_.'Event' -like 'Extern senden'})

## Receive 
$recMTD|select-object *
$recMTD|select-Object -expandproperty Data
($recMTD|select-Object -expandproperty Data) -split '<' -replace '>',''

## Submit Store Message in MailboxStore
$subMTD|select-object *
$subMTD|select-Object -expandproperty Data
($subMTD|select-Object -expandproperty Data) -split '<' -replace '>',''

## Send to external
$sndMTD|select-object *
($sndMTD|select-Object -expandproperty Data) -split '<' -replace '>',''
### Outbound sending process analysis 
(($sndMTD|select-Object -expandproperty Data) -split '<' -replace '>',''|select-string -Pattern 'MEP Name="CustomData"') -split ':'

# INBOUND
Get-Messagetrace |select-object -first 1|select-object * -OutVariable ibmt
Get-Messagetrace |select-object -first 1|select-object Messageid,Recipientaddress,Messagetraceid

Get-MessageTraceDetail -MessageTraceId $ibmt.MessagetraceId -RecipientAddress $ibmt.Recipientaddress -OutVariable ibmtd

$ibmtd.Where({$.Event -like Empfangen})|Select-object Event,Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$ibmtd.Where({$.Event -like Transportregel})|Select-object Event,Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate
$ibmtd.Where({$.Event -like Zustellen})|Select-object Event,Action,SenderAddress,RecipientAddress,Index,Startdate,EndDate

# Outbound Mail Delivery Report
$RA = 'info@powershell.co.at'
Get-messagetrace -Recipientaddress $rA|ForEach-Object {
    $Mtd = Get-MessageTraceDetail -MessageTraceId $_.MessageTraceid -RecipientAddress $_.Recipientaddress
    $Deliverytime = New-Timespan -Start ($mtd.Where({$_.Event -like 'Empfangen'})).Date -End ($mtd.Where({$_.Event -like 'Extern senden'})).Date
    $deltimeformatted = "{0:hh}:{0:mm}:{0:ss}:{0:ffff}" -f $Deliverytime
    Write-Host "Delivery Time for Message $($_.Subject) was $deltimeformatted"
}

Get-HistoricalSearch


# Creating Transportrules with JSON FIles
Get-TransportRule -Identity 'Set X-Header X-ELAT-Maildirection Inbound' -outvariable TR

## Count Number of objects
$tr|Select-Object *|Get-member -MemberType Noteproperty |Measure-Object

$RuleSettings = Get-Content ./Samplerule.json -Raw|Convertfrom-Json -AsHashtable
New-TransportRule @RuleSettings
Remove-transportrule -identity $ruleSettings.Name -Confirm:$false

