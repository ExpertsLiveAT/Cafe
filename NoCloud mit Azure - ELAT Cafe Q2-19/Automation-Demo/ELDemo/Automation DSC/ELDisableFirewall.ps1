Configuration ELDisableFirewall
{
    Node EmptyNode
    {
         Script DisableFirewall 
        {
            GetScript = {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = -not('True' -in (Get-NetFirewallProfile -All).Enabled -eq $true)
                }
            }

            SetScript = {
                Set-NetFirewallProfile -All -Enabled False -Verbose
            }

            TestScript = {
                $Status = -not('True' -in (Get-NetFirewallProfile -All).Enabled -eq $true)
                $Status -eq $True
            }
        }
    }
}