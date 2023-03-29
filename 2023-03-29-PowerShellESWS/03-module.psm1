<#
Mandatory Parameters
#>

function New-MyMGUser {
    [CmdLetBinding(
            ConfirmImpact = 'Low',
        SupportsShouldProcess = $true
              )
    ]

    param (
        [Parameter(Mandatory = $true)]    
        $displayName,
        
        [Parameter(Mandatory = $true)]
        $userPrincipalName,
        
        [Parameter(Mandatory = $true)]
        $mailNickName,
        
        [Validatepattern('(?=^.{8,255}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*')]
        $password = 'xWwvJ]6NMw+bWH-d',

        [ValidateSet('AT','CH','DE','IT')]
        $Country


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
                      Country = $Country
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
        [Parameter(Mandatory = $true)]
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


