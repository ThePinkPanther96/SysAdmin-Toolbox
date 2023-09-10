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


## Usage
Here are examples of a few of the key functions in the code:

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
