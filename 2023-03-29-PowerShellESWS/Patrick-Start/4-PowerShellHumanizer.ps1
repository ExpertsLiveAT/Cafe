##
## PowerShell Humanizer
## WahlPatr
##
## Resourcen:
## + https://github.com/dfinke/PowerShellHumanizer
##


return 'You shall not pass'

Install-Module powershellhumanizer

Get-Module powershellhumanizer -ListAvailable

Get-Command -Module Powershellhumanizer

## In Select
Get-Command -Module PowerShellHumanizer |  select Humanized, Name

## Singular / Plural

@('Person', 'Man', 'Woman', 'Knive') | ConvertTo-Plural

@('Person', 'Man', 'Woman', 'Knive') | ConvertTo-Plural | ConvertTo-Singular

## Numbers

112..122 | ConvertTo-OrdinalWords

112..122 | ConvertTo-RomanNumeral

(112).Ordinalize()

(113).ToWords()

"Now: $(Get-Date). In three weeks: $((Get-Date) + (3).Weeks)"

## Strings

'we love powershell'.ToTitleCase()

'21.Juni - Experts Live Konferenz Au'.Underscore()

'Experts Live ist die beste Konferenz. Es gibt Tracks zu Security, Azure and Hybrid Themen.'.Truncate(6, 'Words')

## Date

(get-date '2023-07-21').Humanize()

$output = (get-date) - ((get-date).AddMinutes(-5))

$output

Get-ChildItem  # -> show in other terminal without PSHumanizer

Remove-Module Powershellhumanizer

$output

## FileSytem Format

