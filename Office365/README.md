# Remove Malicious Emails 
## Introduction
The purpose of this script is to provide a user-friendly way, with a user interface (GUI), to search for and manage email messages in an Exchange Online environment. Users can connect using different authentication methods (MFA or non-MFA), search for specific emails, view search results, and delete potentially malicious emails if needed. It also checks the connection status to Exchange Online and handles errors gracefully.

## Requirements
- Access to an Exchange Online Environment.
- PowerShell 5 or higher.
- Exchange Online PowerShell Module.
- MFA Module Installed (if applicable).
- Valid credentials to connect to Exchange Online.

## Configuration
This code block is used to set up a connection to Microsoft Exchange Online using PowerShell. It imports the necessary modules, creates a secure credential, establishes a remote PowerShell session, and connects to Exchange Online. Once connected, you can execute Exchange Online cmdlets to manage your Exchange Online environment programmatically:

```nh
Import-Module MSOnline
$SecPass = ConvertTo-SecureString "<Password>" -AsPlainText -Force
$O365Cred = New-Object System.Management.Automation.PSCredential ("YourEmail@Example.com", $SecPass)
$O365Session = New-PSSession ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session
Connect-MsolService -Credential $O365Cred
```
### Let's break it down
1. Import the "MSOnline" module to enable Microsoft 365 and Exchange Online management functions:
```nh
Import-Module MSOnline
```
2. Create secure credentials. Replace "YourUsername@YourDomain.com" and "YourPassword" with your Office 365 account credentials.
   Ensure your password is stored securely as a secure string:
```nh
$SecPass = ConvertTo-SecureString "YourPassword" -AsPlainText -Force
$O365Cred = New-Object System.Management.Automation.PSCredential ("YourUsername@YourDomain.com", $SecPass)
```
3. Create a remote PowerShell session to connect to Exchange Online. Provide the necessary configuration details, including the Connection URI:
```nh
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
```
4. Import the PowerShell session you just created. This allows you to use Exchange Online cmdlets in your current PowerShell session:
```nh
Import-PSSession $O365Session
```
5. Finally, connect to Microsoft Online Services (such as Azure AD) using your credentials. This step may be necessary for certain management tasks:
```nh
Connect-MsolService -Credential $O365Cred
```

## Setup
These variables need to be populated with the appropriate values based on your specific requirements and environment.
1. This variable should be assigned the path where you want to save the CSV file that will contain the search results (By default, it's set to resolve the path to your desktop):
```nh
$path = Resolve-Path ~\Desktop
```
2. This variable specifies the name of the CSV file that will store the search results:
```nh
$file = '\Search_Results.csv'
```

## Manual
1. Execute the script.
2. Choose Authentication Method. The program offers options for authentication, such as Multi-Factor Authentication (MFA) or non-MFA. Select the appropriate authentication method based on your account setup.
3. Fill in Search Criteria:
   - Sender Email Address
   - Message Subject
   - Number of Days to Search (how far back in time to search for emails).

  4. Click "Search For The Emails". After entering your search criteria, click the "Search For The Emails" button in the GUI.
  5. View and Export Results. will perform the search and display the results. You can view the number of matching emails and other relevant information.
     Click the "Open The Search Result Log File" button to view and analyze the search results.
  7. Delete Malicious Emails (Optional). Click the "Delete The Malicious Emails And Close" button if you wish to proceed with email deletion.
  8. The script will display a connection status indicating whether you are connected to Microsoft Exchange Online. Ensure that the status is "Connected to Exchange" before proceeding.




# GetMsolUserReport
## Introduction
The purpose of this script is to Generate a CSV report containing both general and Exchange Online-related information about users in Office 365.

This script will establish a connection with the Office 365 provision web service API and Exchange Online (https://ps.outlook.com/powershell) and collect information about users including licenses, mailbox usage, retention, ActiveSync devices, etc.

## Description 
If a credential is specified, it will be used to establish a connection with the provisioning web service API. 

If a credential is not specified, an attempt is made to identify an existing connection to the provisioning web service API. 

If an existing connection is identified, the existing connection is used.  

If an existing connection is not identified, the user is prompted for credentials so that a new connection can be established.
			
If a credential is specified, it will be used to establish a new remote PowerShell session connected to Exchange Online.  If a PowerShell session(s) exists that is connected to Exchange Online, the session(s) will be removed so that a new session can be created using the specified credential.
		
If a credential is not specified, an attempt is made to connect to Exchange Online.  If the connection attempt is successful, the existing connection is used.  If it is not successful, the user is prompted for credentials so that a new connection can be established. 

## Parameter output
Specifies the name of the output file. The argument can be the full path including the file name, or only the path to the folder in which to save the file (uses the default name). The default filename is in the format of "YYYYMMDDhhmmss_MsolUserReport.csv"

### Additional details and examples are provided in the code. 


## Configuration
Here are examples for few of the key functions in the code:

#### Use the discretion and examples in 'ConnectProvisioningWebServiceAPI' function for connecting to Office 365 provisioning web service API:
```
Function ConnectProvisioningWebServiceAPI
{
	<#
		.SYNOPSIS
			Connects to the Office 365 provisioning web service API.

		.DESCRIPTION
			Connects to the Office 365 provisioning web service API.
			
			If a credential is specified, it will be used to establish a connection with the provisioning
			web service API.
			
			If a credential is not specified, an attempt is made to identify an existing connection to
			the provisioning web service API.  If an existing connection is identified, the existing
			connection is used.  If an existing connection is not identified, the user is prompted for
			credentials so that a new connection can be established.

		.PARAMETER Credential
			Specifies the credential to use when connecting to the provisioning web service API
			using Connect-MsolService.

		.EXAMPLE
			PS> ConnectProvisioningWebServiceAPI

		.EXAMPLE
			PS> ConnectProvisioningWebServiceAPI -Credential
			
		.INPUTS
			[System.Management.Automation.PsCredential]

		.OUTPUTS

		.NOTES

# Rest of the code...

	#>
```

#### Use the discretion and examples in 'ConnectExchangeOnline' function for Connecting to the Exchange Online PowerShell web service:
```
Function ConnectExchangeOnline
{
	<#
		.SYNOPSIS
			Connects to the Exchange Online PowerShell web service (http://ps.outlook.com/powershell).

		.DESCRIPTION
			Connects to the Exchange Online PowerShell web service (http://ps.outlook.com/powershell).
			
			If a credential is specified, it will be used to establish a new remote PowerShell session connected
			to Exchange Online.  If a PowerShell session(s) exists that is connected to Exchange Online, the 
			session(s) will be removed so that a new session can be established using the specified credential.
			
			If a credential is not specified, an attempt is made to connect to Exchange Online. If the connection
			attempt is successful, the existing connection is used.  If it is not successful, the user is prompted
			for credentials so that a new connection can be established.

		.PARAMETER Credential
			Specifies the credential to use when connecting to Exchange Online.

		.EXAMPLE
			PS> ConnectExchangeOnline

		.EXAMPLE
			PS> ConnectExchangeOnline -Credential
			
		.INPUTS
			[System.Management.Automation.PsCredential]

		.OUTPUTS
			

		.NOTES

	#>

# Rest of the code...
```

#### Use the discretion and examples in 'GetUser' function for getting information for a specific user account:
```
Function GetUser
{
	<#
		.SYNOPSIS
			Gets user information using the Exchange cmdlet "Get-User".

		.DESCRIPTION
			Gets user information using the Exchange cmdlet "Get-User".

		.PARAMETER UserPrincipalName
			Specifies the UserPrincipalName of the identity about which	to collect information.

		.EXAMPLE
			PS> GetUser -UserPrincipalName "john.doe@contoso.com"

		.INPUTS
			System.String

		.OUTPUTS
			System.Management.Automation.PSCustomObject

		.NOTES
			
	#>

# Rest of the code...

```     

#### Use the discretion and examples in 'GetUser' function for getting recipient information:
```
Function GetRecipient
{
	<#
		.SYNOPSIS
			Gets recipient information using the Exchange cmdlet "Get-Recipient".

		.DESCRIPTION
			Gets user information using the Exchange cmdlet "Get-Recipient".

		.PARAMETER UserPrincipalName
			Specifies the UserPrincipalName of the identity about which	to collect information.

		.EXAMPLE
			PS> GetRecipient -UserPrincipalName "john.doe@contoso.com"

		.INPUTS
			System.String

		.OUTPUTS
			System.Management.Automation.PSCustomObject

		.NOTES

# Rest of the code...
	#>
```

#### Use the discretion and examples in 'GetUser' function for getting mailbox-enabled user information:
```
Function GetMailbox
{
	<#
		.SYNOPSIS
			Gets mailbox-enabled user information using the Exchange cmdlet "Get-Mailbox".

		.DESCRIPTION
			Gets mailbox-enabled user information using the Exchange cmdlet "Get-Mailbox".

		.PARAMETER UserPrincipalName
			Specifies the UserPrincipalName of the identity about which	to collect information.

		.EXAMPLE
			PS> GetMailbox -UserPrincipalName "john.doe@contoso.com"

		.INPUTS
			System.String

		.OUTPUTS
			System.Management.Automation.PSCustomObject

		.NOTES
			
	#>
# Rest of the code...
```

#### Use the discretion and examples in 'GetSecondarySMTPAddresses' function for getting information regarding secondary mailboxes: 
```
Function GetSecondarySMTPAddresses
{
	<#
		.SYNOPSIS
			Gets the secondary SMTP addresses of an object.

		.DESCRIPTION
			Gets the secondary SMTP addresses of an object.

		.PARAMETER ProxyAddresses
			Specifies the proxyAddresses attribute to parse in order to determine
			the secondary SMTP addresses.

		.EXAMPLE
			PS> GetSecondarySMTPAddresses -ProxyAddresses $ProxyAddresses

		.INPUTS
			System.String[]

		.OUTPUTS
			System.String

		.NOTES

	#>
# Rest of the code...
```

#### Please read the comments and descriptions within the code carefully to gain a deeper understanding of each function and its purpose. Each function is accompanied by its own description and examples, making it accessible even to those without extensive expertise in PowerShell or Office 365 services.


