Param(
    [Parameter(Mandatory)]
    [ValidateScript({[System.Guid]::TryParse($_, [REF]$_)})]
    [string]$SubscriptionId,

    [Parameter(Mandatory)]
    [ValidatePattern('^[\w.]{0,89}\w$')]
    [string]$ResourceGroup,

    [Parameter(Mandatory)]
    [ValidatePattern('^\w{3,10}$')]
    [string]$Environment
)
$ErrorActionPreference = "Stop"

$swaggerFilePath = "swagger.json"
$policyFilePath = "policy.xml"
$templateFilePath = "azure.template.json"

$parametersFile = "azure.parameters.$Environment.json"
$parametersFilePath = "parameters/$parametersFile"

if (!(Test-Path -Path $parametersFilePath)) {
    throw "Parameters file '$parametersFile' not found!"
}

try {
    Set-AzureRmContext -SubscriptionId $SubscriptionId | Out-Null
}
catch {
    throw "Unable to switch context to subscription id '$SubscriptionId', $($_.Exception.Message)"
}

try {
    Get-AzureRmResourceGroup -ResourceGroupName $ResourceGroup | Out-Null
}
catch {
    throw "Unable to find resource group '$ResourceGroup', $($_.Exception.Message)"
}

$swagger = (Get-Content -Path $swaggerFilePath -Raw).ToString()
$policy = (Get-Content -Path $policyFilePath -Raw).ToString()

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup `
                                    -TemplateFile $templateFilePath `
                                    -TemplateParameterFile $parametersFilePath `
                                    -apiSwagger $swagger `
                                    -apiPolicy $policy | Select-Object -Property ProvisioningState,Timestamp,Mode,Outputs