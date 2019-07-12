 <#
.SYNOPSIS
    Create User Account (On-Prem Active Directory)

.DESCRIPTION
    Create User Account in On-Prem Active Directory
    Set Firstname, Lastname and Loginname.
 
.PARAMETER Firstname
    Define Users Firstname
    
.PARAMETER Lastname
    Define Users Lastname
    
.PARAMETER Loginname
    Define User Loginname
    
#>


param(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)

# HybridWorker run with privileged permissions
Write-Output "Start Script on HybridWorker with privileged permissions"

$NewUser = (ConvertFrom-Json -InputObject $WebhookData.RequestBody)

New-ADUser -DisplayName "$($NewUser.Firstname) $($NewUser.Lastname)" -Surname $NewUser.Firstname -Name $NewUser.Loginname `
           -GivenName $NewUser.Lastname -ChangePasswordAtLogon $true `
           -AccountPassword (Get-AutomationPSCredential -Name 'DefaultUserPW').Password -Enabled $true `
           -UserPrincipalName "$NewUser.Loginname@eldemo.local"

# HybridWorker run with default Permission, script get credentials inline
<#
Write-Output "Start Script on HybridWorker without privileged permissions"
$domainAdmin = Get-AutomationPSCredential -Name 'HybridWorkerAccount'
$domainAdminCredential = New-Object System.Management.Automation.PSCredential ($domainAdmin.UserName, $domainAdmin.Password)

# add credential parameter to all AD commands
$PSDefaultParameterValues=@{ "*-AD*:Credential"=$domainAdminCredential ;}
New-ADUser -Name "TestUser01"
#>