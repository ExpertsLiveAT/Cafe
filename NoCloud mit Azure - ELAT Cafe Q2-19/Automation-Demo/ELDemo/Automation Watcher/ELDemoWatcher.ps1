 <#
.SYNOPSIS
    Create User Account (On-Prem Active Directory)

.DESCRIPTION
    Create User Account in On-Prem Active Directory
    Set Firstname, Lastname and Loginname.
    
#>


$FilePath = "C:\ELAutomation\WatcherTask"

if((Get-ChildItem -Path $FilePath).Count -gt 0)
{
    $NewADUser = [System.Collections.ArrayList]@()    

    foreach ($File in (Get-ChildItem -Path $FilePath).FullName)
    {
        Write-Output "Read File $File"
        
        foreach ($Line in (Get-Content $File))
        {
            [array]$userinfo = $Line.Split(";")

            if ($userinfo.Length -eq 3)
            {
                $Properties = [System.Collections.ArrayList]@()
                $Properties = @{"Firstname"=$userinfo[0];
                                "Lastname"=$userinfo[1];
                                "Loginname"=$userinfo[2];}

                $NewADUser.Add($Properties)
            }
        }  
        
        Remove-Item -Path $File                    
    }

    $Data = $NewADUser | ConvertTo-Json

    if ($Data.Length -gt 0)
    {
        Write-Output $Data
        Invoke-AutomationWatcherAction -Message "Create VM" -Data $Data
    }
}

