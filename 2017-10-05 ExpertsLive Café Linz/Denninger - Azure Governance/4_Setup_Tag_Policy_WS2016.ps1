$resourceGroupNames='expertsliveaustria2017ws16'

$context = Get-AzureRmContext
$subscription = $context.Subscription.SubscriptionId

try
{
    $policy = New-AzureRmPolicyDefinition -Name "Windows Server ELAT17 policy definition" -Description "Policy only Win Server 2016" -Policy '{
      "if": {
        "allOf": [
          {
            "field": "type",
            "in": [
              "Microsoft.Compute/disks",
              "Microsoft.Compute/virtualMachines",
              "Microsoft.Compute/VirtualMachineScaleSets"
            ]
          },
          {
            "not": {
              "allOf": [
                {
                  "field": "Microsoft.Compute/imagePublisher",
                  "in": [
                    "MicrosoftWindowsServer"
                  ]
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "in": [
                    "WindowsServer"
                  ]
                },
                {
                  "field": "Microsoft.Compute/imageSku",
                  "in": [
                    "2016-Datacenter"
                  ]
                },
                {
                  "field": "Microsoft.Compute/imageVersion",
                  "in": [
                    "latest"
                  ]
                }
              ]
            }
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }' -Verbose -ErrorAction Stop
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}

try
{
    foreach($resourceGroupName in $resourceGroupNames){
        New-AzureRmPolicyAssignment -Name "Windows Server $resourceGroupName policy assignment" -PolicyDefinition $policy -Scope "/subscriptions/$subscription/resourceGroups/$resourceGroupName" -Verbose -ErrorAction Stop
    }
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}