$resourceGroupNames='expertsliveaustria2017'
$department='Solutions Sales'
$environment='development'
$costCenter='35440'
$policyParameterObject = @{"department"=$department;"environment"=$environment;"costcenter"=$costCenter}

$context = Get-AzureRmContext
$subscription = $context.Subscription.SubscriptionId

# ADD Tags für Department - Enviroment - Kostenstelle

try
{
    $policy =  '{
      "if": {
        "field": "tags",
        "exists": "false"
      },
      "then": {
        "effect": "append",
        "details": [
          {
            "field": "tags",
            "value": {"department":"[parameters(''department'')]","environment":"[parameters(''environment'')]","costCenter":"[parameters(''costcenter'')]"}
          }
        ]
      }
    }'
    
    $parameters = '{
      "department": {
        "type": "string",
        "metadata": {
          "description": "Department name",
          "strongType": "department",
          "displayName": "department"
        }
      },
      "environment": {
        "type": "string",
        "metadata": {
          "description": "Environment name",
          "strongType": "environment",
          "displayName": "environment"
        }
      },
      "costcenter": {
        "type": "string",
        "metadata": {
          "description": "Cost center",
          "strongType": "costcenter",
          "displayName": "costcenter"
        }
      }
    }'

    $definition=New-AzureRmPolicyDefinition -Name "Advanced ELAT 17 tagging policy definition" -Description "Policy to append tags" -Policy $policy -Parameter $parameters -Verbose -ErrorAction Stop
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
        New-AzureRmPolicyAssignment -Name "Advanced $resourceGroupName tagging policy assignment" -PolicyDefinition $definition -PolicyParameterObject $policyParameterObject  -Scope "/subscriptions/$subscription/resourceGroups/$resourceGroupName" -Verbose -ErrorAction Stop
    }
}
catch
{
    Write-Host $_
    Write-Output 'ERROR:'
    Write-Output $_
    Pause
}