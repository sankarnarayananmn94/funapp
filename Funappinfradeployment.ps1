$resourceGroupName = "icg-uat-app-rg01"
$location = "CentralIndia"
$keyVaultName = "icg-uat-app-keyval01"
$secretName = "icg-uat-app-keyvalsec01"
$secretValue = "blackpearl@2024"
$apiManagementServiceName = "icg-uat-app-apims01"
$organizationName = "icg-uat-demo"
$adminEmail = "sankar.narayananmn@outlook.com"
$storageAccountName01 = "icguatappsa01"
$storageAccountName02 = "icguatappsa02"
$storageAccountName03 = "icguatappats01"
$storageAccountName04 = "icguatappadls01"
$functionsAppName01 = "icg-uat-app-fai01"
$functionsAppName02 = "icg-uat-app-fai02"
$tableName01 = "icguatapptab01"
$eventGridTopicName = "icg-uat-app-egt01"

New-AzResourceGroup -Name $resourceGroupName -Location $location

New-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -Location $location

Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName -SecretValue (ConvertTo-SecureString $secretValue -AsPlainText -Force)

New-AzApiManagement -ResourceGroupName $resourceGroupName -Location $location -Name $apiManagementServiceName -Organization $organizationName -AdminEmail $adminEmail

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName01 -Location $location -SkuName Standard_LRS

New-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $functionsAppName01 -StorageAccount $storageAccountName01 -Location $location -Runtime "node" -RuntimeVersion "20" -FunctionsVersion 4

$functionApp = Get-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $functionsAppName
Set-AzWebApp -ResourceGroupName $resourceGroupName -Name $functionsAppName -AssignIdentity $true

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName02 -Location $location -SkuName Standard_LRS

New-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $functionsAppName02 -StorageAccount $storageAccountName02 -Location $location -Runtime "node" -RuntimeVersion "20" -FunctionsVersion 4

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName03 -Location $location -SkuName Standard_LRS -Kind StorageV2

$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName03).Context
New-AzStorageTable -Name $tableName01 -Context $context

New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName04 -Location $location -SkuName Standard_LRS -Kind StorageV2 -EnableHierarchicalNamespace $true

New-AzEventGridTopic -ResourceGroupName $resourceGroupName -Location $location -Name $eventGridTopicName

$functionsApp = Get-AzFunctionApp -ResourceGroupName $resourceGroupName -Name $functionsAppName01
$principalId = $functionsApp.Identity.PrincipalId

Write-Output "Principal ID: $principalId"

Connect-AzureAD

$objectId = (Get-AzureADServicePrincipal -Filter "DisplayName eq '$functionsAppName01'").ObjectId

Write-Output "Object ID: $objectId"

$keyVault = Get-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName

Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretName -SecretValue (ConvertTo-SecureString $secretValue -AsPlainText -Force)

Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId $objectId -PermissionsToSecrets get,set,list