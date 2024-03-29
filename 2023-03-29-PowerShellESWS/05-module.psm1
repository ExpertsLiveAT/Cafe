<#
Range Validation
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
        $Country,

        [ValidateRange(10000, 99999)]
        $EmployeeID

    )
    begin {
        
    }
    process {

        $PasswordProfile = @{
            Password = $password
        }

        $NewMgUserParam = @{
            DisplayName       = $DisplayName
            PasswordProfile    = $PasswordProfile 
            UserPrincipalName = $UserPrincipalName 
            AccountEnabled    = $true
            MailNickname      = $mailNickName
        }
        if ($country) {$NewMGUserparam.Country = $Country}        
        if ($employeeId) {$NewMGUserparam.employeeId = $EmployeeId}        

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
        [ValidateScript({if (Get-MGUser -UserId $_) {$true} else {throw "Userid $_ does not exist, check for typos"}})]
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


