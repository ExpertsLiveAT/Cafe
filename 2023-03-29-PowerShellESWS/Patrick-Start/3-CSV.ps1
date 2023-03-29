##
## PowerShell Workshop
##

Write-Host 'Maybe you should not pass!'

#region Generate CSV (needed for demo)

get-process |  export-csv -path '3-Process.csv' -Delimiter ',' # bunt

get-childitem | select directory, name, length | export-csv -path '3-Dir.csv' -Delimiter ',' -Encoding Default -NoTypeInformation # übersichtlich

# Show CSV functions / remove csv
$Remove  = import-csv '3-Dir.csv' | Where-Object Todo -eq 'Remove' | foreach-object {get-childitem $_.Name} 
$Remove | Remove-Item -Force