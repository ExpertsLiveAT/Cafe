$resourceGroupNames='expertsliveaustria2017'
$resourceGroupNames=@()
$resourceGroupNames+='Rocks-IaaS-RG'

$context = Get-AzureRmContext
$subscription = $context.Subscription.SubscriptionId

try
{
    $policy = New-AzureRmPolicyDefinition -Name "Basic ELAT 17 tagging policy definition" -Description "Policy to append tags" -Policy '{
      "if": {
        "field": "tags",
        "exists": "false"
      },
      "then": {
        "effect": "append",
        "details": [
          {
            "field": "tags",
            "value": {"department":"Solutions Sales","environment":"ACPcloud.rocks"}
          }
        ]
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
        New-AzureRmPolicyAssignment -Name "Basic $resourceGroupName tagging policy assignment" -PolicyDefinition $policy -Scope "/subscriptions/$subscription/resourceGroups/$resourceGroupName" -Verbose -ErrorAction Stop
    }
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}