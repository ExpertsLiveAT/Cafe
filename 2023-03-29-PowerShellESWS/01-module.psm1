<#
Add [CmdLetBinding()]
#>

function New-MyMGUser {
    [CmdLetBinding(
            ConfirmImpact = 'Low',
        SupportsShouldProcess = $true
              )
    ]

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

        if ($PsCmdLet.ShouldProcess("$UserprincipalName", "Create MS-Graph user")) {
            New-MgUser @NewMgUserParam
        }

    }
    end {
    }
}

function Remove-MyMGUser {
    [CmdLetBinding(
                   ConfirmImpact = 'High',
          SupportsShouldProcess = $true
              )
    ]

    param (
        $userPrincipalName
    )
    begin {
        
    }
    process {
        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Removing user: ")) {
            Remove-MgUser -UserId $UserPrincipalName
        }
    }
    end {
    }
}


