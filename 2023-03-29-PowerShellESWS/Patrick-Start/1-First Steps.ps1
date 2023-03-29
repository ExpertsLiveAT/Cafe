<#
   PowerShell Workshop
#>
return 'You should not pass!'
#region Step 1 - Get help :)

Get-Help -Name Get-Help -Full

<#
Die Hilfedateien für dieses Cmdlet können von "Get-Help" auf diesem Computer nicht gefunden werden. Es wird nur ein Teil der Hilfe angezeigt.
-- Sie können die Hilfedateien für das Modul, das dieses Cmdlet enthält, herunterladen und installieren, indem Sie "Update-Help" verwenden.
-- Wenn Sie das Hilfethema für dieses Cmdlet online anzeigen möchten, geben Sie Folgendes ein: "Get-Help Get-Command -Online", oder
   gehen Sie zu "https://go.microsoft.com/fwlink/?LinkID=113309".
#>
Update-help

Get-Help -Name Get-Command

get-command -name get-command 

#endregion Step 1
#region Aliases

# Show region functions
get-alias

ls
dir
Get-childitem

#endregion Aliases

# Start debugging :)
