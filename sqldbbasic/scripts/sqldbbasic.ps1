<# 
.SYNOPSIS
    This script performs post-deployment configuration for an Azure SQL Database and will perform operations that cannot currently be performed in an ARM template at deployment time.

.DESCRIPTION
    This script will perform the following post-deployement configuration operations:
    1. Enable SQL Server Auditing by setting the audit policy to "ON". It assumes that a storage account has already been allocated which has the same name as the SQL Server with "stg" appended to it.
    2. Enable SQL auditing for the database. The same storage account is used as for the SQL Server.
    3. Enable SQL Database threat detection.
    4. Turn on TDE to encrypt the database.
    5. Configure SQL Azure AD integration and set the Active Directory Administrator.

.PARAMETER resourceGroupName
    String name of the resource group that contains the Azure SQL Server and Database.

.PARAMETER serverName
    String name of the logical SQL Server.

.PARAMETER databaseName
    String name of the SQL Database.

.PARAMETER retentionDays
    Integer. The number of days to retain audit events.

.PARAMETER storageAccountName
    String name of the storage account to be used for audit events.

.PARAMETER notificationRecipientEmails
    String containing a semicolon-delimited list of email addresses to be notified by Azure SQL Threat Detection.

.PARAMETER activeDirectoryAdministrator
    String name of an Azure AD user or security group to be set as the SQL AD administrator. A best practice is to use a security group rather than an individual user.

.PARAMETER azureSubscriptionName
    String name of the Azure subscription containing the SQL DB
    
.NOTES 

    LASTEDIT: 08/08/2016
     
#>
# Login-AzureRmAccount  
# Get-AzureRmSubscription

# Provide the Azure subscription name
$azureSubscriptionName = "Windows Azure Internal Consumption"
# Provide the name of the resource group that contains the SQL DB
$resourceGroupName = "appxxrg1"
# Provide the name of the logical server that hosts the SQL DB
$serverName = "appxxsqll01"
# Provide the name of the Azure SQL Database
$databaseName = "appxxsql01db"
# Provide the number of days to retain SQL audit events (1 -7 days)
$retentionDays = 7
# Provide the storage account to be use for the audit events
$storageAccountName = $serverName + "stg"
# Indicate which storage key will be used to access the storage account for audit data
$storageKeyType = "Primary"
# Indicate whom to send notification emails to (comma-delimited list) by Azure SQL Threat Detection
$notificationRecipientsEmails = "user@microsoft.com"
# Provide the Active Directory userid or security group to be configured as the SQL AD Administrator
$activeDirectoryAdministrator = "App XX DBA Team"

# Set the Azure subscription
Get-AzureRmSubscription -SubscriptionName $azureSubscriptionName | Select-AzureRmSubscription
