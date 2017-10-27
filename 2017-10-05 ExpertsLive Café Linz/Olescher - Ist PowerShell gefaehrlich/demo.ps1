### expertslivecafe-2017-10-05-slides-olescher.htm: scripts ###
### christian.olescher@bbrz-gruppe.at                       ###
exit


### PowerShell 2.0
#
# CMD: powershell.exe -Version 2.0
#
$PSVersionTable
#
# PSVersion = 2.0, PSCompatibleVersion = {1.0, 2.0} ==> PowerShell 2.0 is installed
#
# https://docs.microsoft.com/en-us/powershell/wmf/5.1/install-configure
# 

# Server
Remove-WindowsFeature PowerShell-V2

# Client
Disable-WindowsOptionalFeature –Online -FeatureName MicrosoftWindowsPowerShellV2Root -Remove


### ExecutionPolicy is not a security boundary
#
# CMD: powershell.exe -ExecutionPolicy Unrestricted
#
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
Set-ExecutionPolicy Unrestricted -Scope Process


### Signatur
#
$cert = New-SelfSignedCertificate -Type CodeSigningCert -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=Marianne Developerin,OU=dev,DC=corp,DC=acme,DC=com"
Set-AuthenticodeSignature .\demo.ps1 $cert


### Remoting / JEA
#
Get-ChildItem WSMan:\localhost\Listener
(Get-ChildItem WSMan:\localhost\Listener)[0] | Get-ChildItem

Get-PSSessionConfiguration

# Second hop
# https://docs.microsoft.com/en-us/powershell/scripting/setup/ps-remoting-second-hop?view=powershell-5.1


### AppLocker und DeviceGuard
#
$ExecutionContext.SessionState.LanguageMode


### Credentials in CliXML statt im Credential Manager
#
$cred1 = Get-Credential
$cred1 | Export-Clixml creds.clixml

Get-Content .\creds.clixml | Out-GridView

$cred2 = Import-Clixml creds.clixml
$cred2.UserName
$cred2.GetNetworkCredential().Password


###
