### Works flawlessly in Office 365 Exchange Online only
### Connect to Exchange Online
 
Install-Module ExchangeOnlineManagement -Force -AllowClobber
<# 
-Force: Installs a module and overrides warning messages about module installation conflicts. 
If a module with the same name already exists on the computer, Force allows for multiple versions to be installed. 
If there is an existing module with the same name and version, Force overwrites that version. 
-AllowClobber: Overrides warning messages about installation conflicts about existing commands on a computer. 
Overwrites existing commands that have the same name as commands being installed by a module.
AllowClobber and Force can be used together in an Install-Module command.
#>
Connect-ExchangeOnline

Set-Location C:\
Clear-Host

### Set Auto-Reply on User

Set-MailboxAutoReplyConfiguration -Identity f.bizeps `
-InternalMessage "Internal auto-reply message." `
-ExternalMessage "External auto-reply message." `
-AutoReplyState Scheduled `
-StartTime (Get-Date) `
-EndTime (Get-Date).AddDays(30)

Get-Mailbox f.bizeps | Set-MailboxAutoReplyConfiguration -AutoReplyState Disabled

### Retrieve Mailboxes that have Auto-Reply enabled
Get-EXOMailbox -ResultSize Unlimited | 
Get-MailboxAutoReplyConfiguration | 
Where-Object {$_.AutoReplyState -EQ 'Enabled' -or $_.AutoreplyState -EQ 'Scheduled'} | 
Select-Object -Property Identity,AutoreplyState,StartTime,EndTime

### Find Active Sync Users
Get-EXOCASMailbox -ResultSize Unlimited -Filter "Name -notlike '*Discovery*' -and `
ActiveSyncEnabled -eq $true"

Get-EXOCASMailbox -ResultSize Unlimited -Filter "HasActiveSyncDevicePartnership -eq $true" |
Select-Object DisplayName

### List Send, SendAs permissions
Add-RecipientPermission -Identity f.bizeps `
-AccessRights SendAs -Trustee patrick.gruenauer -Confirm:$false

Get-EXOMailbox -ResultSize Unlimited | 
Get-EXORecipientPermission | 
Where-Object {$_.Trustee -notlike "*self*"}

### List Mailbox Permissions
Add-MailboxPermission -Identity f.bizeps `
-User patrick.gruenauer -AccessRights FullAccess -InheritanceType all

Get-EXOMailbox -ResultSize Unlimited | 
Get-EXOMailboxPermission | 
Where-Object {($_.user.tostring() -notlike "*SELF*") `
-and ($_.user.tostring() -notlike "*S-*") `
-and $_.IsInherited -eq $false -and $_.Identity `
-notlike "*discovery*"} | 
Select-Object -Property Identity,User,AccessRights

Remove-MailboxPermission -Identity f.bizeps -User patrick.gruenauer `
-AccessRights FullAccess -Confirm:$false

### List Mailboxes with configured Forwarding Address

# Server Rules
Set-Mailbox -Identity f.bizeps -ForwardingAddress patrick.gruenauer
Set-Mailbox -Identity f.huber -ForwardingSmtpAddress patrick.gruenauer@nowhere.com

Get-Mailbox -ResultSize Unlimited `
-Filter "ForwardingAddress -like '*' -or ForwardingSmtpAddress -like '*'" | 
Select-Object Name,ForwardingAddress,ForwardingSmtpAddress                     

Set-Mailbox -Identity f.huber -ForwardingAddress $null
Set-Mailbox -Identity f.huber -ForwardingSmtpAddress $null

# List Forwarding Rules created by the user (Outlook)
Get-EXOMailbox -ResultSize Unlimited | 
Select-Object -ExpandProperty UserPrincipalName |
Foreach-Object {Get-InboxRule -Mailbox $_  | 
Where-Object {($_.redirectto -ne $null) -or ($_.forwardto -ne $null)} | 
Select-Object -Property MailboxOwnerID,Name,Enabled,From,RedirectTo,ForwardTo}

### List all rules created by the user (Outlook)
Get-EXOMailbox -ResultSize Unlimited | 
Select-Object -ExpandProperty UserPrincipalName |
Foreach-Object {Get-InboxRule -Mailbox $_  | 
Select-Object -Property `
MailboxOwnerID,Name,Enabled,From,Description,RedirectTo,ForwardTo}


### Shared Mailboxes Junk-Mail Settings

# One Mailbox
Set-MailboxJunkEMailConfiguration –Identity "office@domain.at" `
–TrustedSendersAndDomains "bildung.at","sek1@bildung.at"

# Multiple Mailboxes
Get-Mailbox -RecipientTypeDetails SharedMailbox | Set-MailboxJunkEMailConfiguration ...


# Mailbox Restore Deleted Items
Get-ManagementRole -Cmdlet Restore-RecoverableItems # Check: Rolle "Mailbox Import Export" muss dem User zugewiesen sein (Admin Center Rollen)

Get-RecoverableItems -Identity f.bizeps@sid-500.com | Where-Object LastParentPath -eq 'Posteingang' | Measure-Object
Get-RecoverableItems -Identity f.bizeps@sid-500.com -FilterStartTime "13/1/2023 12:00:00 AM" `
-FilterEndTime "28/2/2023 11:59:59 PM" | Where-Object LastParentPath -eq 'Posteingang' | Restore-RecoverableItems -Verbose