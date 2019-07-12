Configuration ELDemoIISConfig
{
    Import-DscResource -ModuleName @{ModuleName = 'xWebAdministration';ModuleVersion = '2.5.0.0'}
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node WebServerConfig
    {
        WindowsFeature WebServer
        {
            Ensure  = 'Present'
            Name    = 'Web-Server'
        }

        WindowsFeature InstallDotNet
        {
            Ensure  = 'Present'
            Name    = 'Web-Asp-Net45'
            DependsOn = '[WindowsFeature]WebServer'
        }

        Script DisableFirewall 
        {
            GetScript = {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = -not('True' -in (Get-NetFirewallProfile -All).Enabled)
                }
            }

            SetScript = {
                Set-NetFirewallProfile -All -Enabled False -Verbose
            }

            TestScript = {
                $Status = -not('True' -in (Get-NetFirewallProfile -All).Enabled)
                $Status -eq $True
            }
        }

        # IIS Site Default Values
        xWebSiteDefaults SiteDefaults
        {
            ApplyTo                 = 'Machine'
            LogFormat               = 'IIS'
            LogDirectory            = 'C:\inetpub\logs\LogFiles'
            TraceLogDirectory       = 'C:\inetpub\logs\FailedReqLogFiles'
            DefaultApplicationPool  = 'DefaultAppPool'
            AllowSubDirConfig       = 'true'
            DependsOn               = '[WindowsFeature]WebServer'
        }

        # IIS App Pool Default Values
        xWebAppPoolDefaults PoolDefaults
        {
           ApplyTo               = 'Machine'
           ManagedRuntimeVersion = 'v4.0'
           IdentityType          = 'ApplicationPoolIdentity'
           DependsOn             = '[WindowsFeature]WebServer'
        }

        Script AddDefaultWebsite
        {
            GetScript = 
            {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = ('True' -in (Test-Path "C:\inetpub\wwwroot\Content.zip"))
                }
            }

            SetScript = 
            {
                Invoke-WebRequest -Uri "https://PATCHtoContend.zip" -OutFile "C:\inetpub\wwwroot\Content.zip"
                Expand-Archive -Path "C:\inetpub\wwwroot\Content.zip" -DestinationPath "C:\inetpub\wwwroot\"
            }

            TestScript = 
            {
                $Status = ('True' -in (Test-Path "C:\inetpub\wwwroot\index.html"))
                $Status -eq $True
            }

        }
    }
}