function New-MyMGUser {
    param (
        $displayName,
        $userPrincipalName,
        $mailNickName,
        $password = 'xWwvJ]6NMw+bWH-d'
    )
    begin {

    }
    process {
        $PasswordProfile = @{
            Password = $password
        }           
        # New-MgUser -DisplayName $DisplayName -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -AccountEnabled -MailNickname $mailNickName
        
        $NewMgUserParam = @{
                  DisplayName = $DisplayName
               PasswordProfile = $PasswordProfile 
            UserPrincipalName = $UserPrincipalName 
               AccountEnabled = $true
                 MailNickname = $mailNickName
        }
        New-MgUser @NewMgUserParam
        
    }
    end {
        
    }
}
$avfunc = Get-Command -Verb 'New' -Noun 'MyMGUser'
Write-Host "Is the new function available during runtime ? see: $avfunc" -BackgroundColor white -ForegroundColor blue

