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












