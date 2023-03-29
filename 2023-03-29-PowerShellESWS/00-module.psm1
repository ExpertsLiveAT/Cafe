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

function Remove-MyMGUser {
    param (
        $userPrincipalName
    )
    begin {

    }
    process {
        Remove-MgUser -UserId $userPrincipalName
    }
    end {
    }
}





