# Remove Malicious Emails 
## Introduction
The purpose of this script is to provide a user-friendly way, with a user interface (GUI), to search for and manage email messages in an Exchange Online environment. Users can connect using different authentication methods (MFA or non-MFA), search for specific emails, view search results, and delete potentially malicious emails if needed. It also checks the connection status to Exchange Online and handles errors gracefully.

## Requirements
- Access to an Exchange Online Environment.
- PowerShell 5 or higher.
- Exchange Online PowerShell Module.
- MFA Module Installed (if applicable).
- Valid credentials to connect to Exchange Online.

## Setup
This code block is used to set up a connection to Microsoft Exchange Online using PowerShell. It imports the necessary modules, creates a secure credential, establishes a remote PowerShell session, and connects to Exchange Online. Once connected, you can execute Exchange Online cmdlets to manage your Exchange Online environment programmatically:

```
Import-Module MSOnline
$SecPass = ConvertTo-SecureString "<Password>" -AsPlainText -Force
$O365Cred = New-Object System.Management.Automation.PSCredential ("YourEmail@Example.com", $SecPass)
$O365Session = New-PSSession ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session
Connect-MsolService -Credential $O365Cred
```

