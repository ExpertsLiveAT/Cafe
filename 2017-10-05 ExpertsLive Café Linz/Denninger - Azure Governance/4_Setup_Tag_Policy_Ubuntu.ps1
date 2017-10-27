$resourceGroupNames='expertsliveaustria2017lx'

$context = Get-AzureRmContext
$subscription = $context.Subscription.SubscriptionId

try
{
    $policy = New-AzureRmPolicyDefinition -Name "Linux ELAT 17 policy definition" -Description "Policy only Ubuntu Linux" -Policy '{
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
                    "Canonical"
                  ]
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "in": [
                    "UbuntuServer"
                  ]
                },
                {
                  "field": "Microsoft.Compute/imageSku",
                  "in": [
                    "*LTS"
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
        New-AzureRmPolicyAssignment -Name "Linux $resourceGroupName policy assignment" -PolicyDefinition $policy -Scope "/subscriptions/$subscription/resourceGroups/$resourceGroupName" -Verbose -ErrorAction Stop
    }
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}