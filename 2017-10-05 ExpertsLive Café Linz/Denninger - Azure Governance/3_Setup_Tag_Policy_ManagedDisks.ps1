$resourceGroupNames='expertsliveaustria2017ws16'

$context = Get-AzureRmContext
$subscription = $context.Subscription.SubscriptionId

try
{
    $policy = New-AzureRmPolicyDefinition -Name "Managed Disks ELAT 17 policy definition" -Description "Policy only Managed Disks" -Policy '{
      "if": {
        "anyOf": [
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Compute/virtualMachines"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/osDisk.uri",
                "exists": true
              }
            ]
          },
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Compute/VirtualMachineScaleSets"
              },
              {
                "anyOf": [
                  {
                    "field": "Microsoft.Compute/VirtualMachineScaleSets/osDisk.vhdContainers",
                    "exists": true
                  },
                  {
                    "field": "Microsoft.Compute/VirtualMachineScaleSets/osdisk.imageUrl",
                    "exists": true
                  }
                ]
              }
            ]
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
        New-AzureRmPolicyAssignment -Name "Managed disks $resourceGroupName policy assignment" -PolicyDefinition $policy -Scope "/subscriptions/$subscription/resourceGroups/$resourceGroupName" -Verbose -ErrorAction Stop
    }
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}