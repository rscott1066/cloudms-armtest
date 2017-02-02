<# 
.SYNOPSIS
    This script performs post-deployment configuration for an Azure Key Vault and will perform operations that cannot currently be performed in an ARM template at deployment time.

.DESCRIPTION
    This script will perform the following post-deployement configuration operations:
    1. Enable logging for the key vault. It is assumed that a storage account to contain the log entires has already been allocated which has the same name as the key vault with "kvstg" appended to it.

.PARAMETER resourceGroupName
    String name of the resource group that contains the Azure key vault.

.PARAMETER keyVaultName
    String name of the key vault.

.PARAMETER retentionDays
    Integer. The number of days to retain audit events.

.PARAMETER azureSubscriptionName
    String name of the Azure subscription that owns the key vault
    
.NOTES 

    LASTEDIT: 09/02/2016

#>
# Login-AzureRmAccount  
# Get-AzureRmSubscription

# Provide the Azure subscription name
$azureSubscriptionName = "<Subscription Name>"
# Provide the name of the resource group that contains the key vault
$resourceGroupName = "<Resource Group Name>"
# Provide the key vault name
$keyVaultName = "<Key Vault Name>"
# Provide the number of days to retain key vault audit events 
$retentionDays = 90
# Provide the storage account to be use for the audit events
$storageAccountName = $keyVaultName + "kvstg"

# Set the Azure subscription
Get-AzureRmSubscription -SubscriptionName $azureSubscriptionName | Select-AzureRmSubscription

# Select the key vault
$kv = Get-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName

# Select the storage account to be used for logging
$sa = Get-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName

# Set the audit policy for the key vault
Set-AzureRmDiagnosticSetting -ResourceId $kv.ResourceId -StorageAccountId $sa.Id -Enabled $true -Categories AuditEvent -RetentionEnabled $true -RetentionInDays $retentionDays
