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
    [Parameter(Mandatory = $false)]
    [String]$Firstname,
    [Parameter(Mandatory = $false)]
    [String]$Lastname,
    [Parameter(Mandatory = $false)]
    [String]$Loginname
)

# HybridWorker run with privileged permissions
Write-Output "Start Script on HybridWorker with privileged permissions"

New-ADUser -DisplayName "$Firstname $Lastname" -Surname $Firstname -Name $Loginname `
           -GivenName $Lastname -ChangePasswordAtLogon $true `
           -AccountPassword (Get-AutomationPSCredential -Name 'DefaultUserPW').Password -Enabled $true `
           -UserPrincipalName "$Loginname@eldemo.local"

# HybridWorker run with default Permission, script get credentials inline
<#
Write-Output "Start Script on HybridWorker without privileged permissions"
$domainAdmin = Get-AutomationPSCredential -Name 'HybridWorkerAccount'
$domainAdminCredential = New-Object System.Management.Automation.PSCredential ($domainAdmin.UserName, $domainAdmin.Password)

# add credential parameter to all AD commands
$PSDefaultParameterValues=@{ "*-AD*:Credential"=$domainAdminCredential ;}
New-ADUser -Name "TestUser01"
#>