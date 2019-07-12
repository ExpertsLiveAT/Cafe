 <#
.SYNOPSIS
    Create User Account (On-Prem Active Directory)

.DESCRIPTION
    Create User Account in On-Prem Active Directory
    Set Firstname, Lastname and Loginname.
 
.PARAMETER EVENTDATA
    Predefined paramter for Azure Watcher Task

    
#>


param(
    $EVENTDATA
)

# HybridWorker run with privileged permissions
Write-Output "Start Script on HybridWorker with privileged permissions"

$NewUser = (ConvertFrom-Json -InputObject $EVENTDATA.EventProperties.Data)

foreach ($User in $NewUser)
{
    Write-Output "Create new User with Parameters: $User"
    New-ADUser -DisplayName "$($User.Firstname) $($User.Lastname)" -Surname $User.Firstname -Name $User.Loginname `
               -GivenName $User.Lastname -ChangePasswordAtLogon $true `
               -AccountPassword (Get-AutomationPSCredential -Name 'DefaultUserPW').Password -Enabled $true `
               -UserPrincipalName "$($User.Loginname)@eldemo.local"

    # HybridWorker run with default Permission, script get credentials inline
    <#
    Write-Output "Start Script on HybridWorker without privileged permissions"
    $domainAdmin = Get-AutomationPSCredential -Name 'HybridWorkerAccount'
    $domainAdminCredential = New-Object System.Management.Automation.PSCredential ($domainAdmin.UserName, $domainAdmin.Password)

    # add credential parameter to all AD commands
    $PSDefaultParameterValues=@{ "*-AD*:Credential"=$domainAdminCredential ;}
    New-ADUser -Name "TestUser01"
    #>
}