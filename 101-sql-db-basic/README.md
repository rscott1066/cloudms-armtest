# Deploy Key Vault and Secret for Azure SQL Database

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frscott1066%2Fcloudms-armtest%2Fmaster%2F101-sql-db-basic%2F101-sql-db-basic-key-vault.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Frscott1066%2Fcloudms-armtest%2Fmaster%2F101-sql-db-basic%2F101-sql-db-basic-key-vault.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to deploy a key vault and associated secret which will be used as the administrative password in an Azure SQL Database deployment

# Deploy Azure SQL DB Server and Database using Key Vault Secret

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frscott1066%2Fcloudms-armtest%2Fmaster%2F101-sql-db-basic%2F101-sql-db-basic.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Frscott1066%2Fcloudms-armtest%2Fmaster%2F101-sql-db-basic%2F101-sql-db-basic.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template allows you to deploy an Azure SQL server and database using a previously configured key vault and associated secret which will be used as the administrative password


# Key Vault Deployment (101-sql-db-basic-key-vault.json)

The Azure Key Vault for SQL template (101-sql-db-basic-Key-vault.json) is intended to be used in conjunction with the Azure SQL Database template (101-sql-db-basic.json) to securely hold the administrative password for the logical SQL Server. Secure storage of the administrative account password in a key vault allows secure storage of the password along with limited access by security administrators. Once the Azure SQL Database template (101-sql-db-basic.json) and associated PowerShell script are used to deploy an Azure SQL Database using the password in the vault Azure Active Directory integration will be configured allowing all further access to databases and Azure SQL capabilities to be controlled via Active Directory users and groups. Following this process ensures that use of the Azure SQL administrative account's password is minimized and that it is never used in the clear.

The Azure Key Vault for SQL template deploys the following:
1. An Azure Key Vault.
2. An initial Key Vault secret to be used as the Azure SQL Database administrative password.
3. An encrypted storage account to contain Key Vault diagnostic and auditing events.

A post-deployment PowerShell script is provided which does the following:
1. Sets the audit policy for the Key Vault to log all audit event types.
2. Sets the audit event retention policy for all audit event types for a specified number of days.

When used in conjunction with the Azure SQL Database template (101-sql-db-basic.json) the Key Vault name and the secret name must both be the same as the name of the SQL logical server.

The following parameters are used in this template:

keyVaultName

This parameter contains the name of the key vault. When used in conjunction with the Azure SQL Database template (SQLDBBasic.json), this name must be the same as the name of the logical SQL Server to be deployed.

tenantID

This parameter is the ID of the Azure subscription to be initially assigned access to the key vault. The value can be obtained by using the Get-AzureRmSubscription PowerShell cmdlet. 

objectID

This parameter is the object ID of the AAD user or service principal that will have access to the vault. The object ID can be obtained by using the Get-AzureRmADUser or the Get-AzureRmADServicePrincipal PowerShell cmdlet.

keysPermissions

This array lists the permissions that will be granted to the user to any keys within the vault. This parameter is not used in this version of the template.

secretsPermissions 

This array lists permissions to grant to secrets within the vault. Valid values are all, get, set, list and delete.

valutSKU

Options are standard or premium

enabledForDeployment

This bool value specifies whether the valut is enabled for template deployments. The default value is true.

enableVaultForVolumeEncryption

This bool value specifies whether the vault is enabled for volume encryption. The default value for this template is false.

secretName

The name of the secret to be stored in the vault. When used in conjunction with the Azure SQL Database template (SQLDBBasic.json), this value should be the same as the name of the Azure SQL logical server.

secretValue

This parameter specifies the value of the secret to store in the vault and is of type securestring.

keyVaultAuditingStorageAccountType

This string value specifies the storage account type for the storage account that will be deployed for containing key vault audit events. The default is Standard_LRS.

A PowerShell script is provided in the scripts subfolder under the template which will perform the following configuration actions following deployment of the ARM template:

1. Configure audit event logging for the vault using the encrypted storage account deployed in the template.
2. Configure audit event retention for the vault.

For proper execution of the script the following parameters must be set prior to execution:

resourceGroupName

This variable must be set to the name of the resource group that contains the vault.

azureSubscriptionName

The name of the Azure subscription that owns the vault.

retentionDays

The number of days to retain audit events.

