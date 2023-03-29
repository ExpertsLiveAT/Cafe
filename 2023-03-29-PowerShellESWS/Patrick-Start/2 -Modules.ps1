##
## PowerShell Workshop
##
return 'You should not pass!'
#region Step 1 - Find Module

[system.Diagnostics.Process]::Start("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", "https://www.powershellgallery.com/packages?q=sql")

#endregion  Step 1 - Find Module

#region Step 2 - Get the Module

get-module
get-module -ListAvailable | out-gridview

install-module -Name PowerShellAI

get-command -Module PowerShellAI

get-module PowerShellAI | select ModuleBase

. explorer.exe (get-module PowerShellAI ).ModuleBase

#endregion Step 2
