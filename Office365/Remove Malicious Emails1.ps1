<#

Version 1.1
Check if the Exchange Online PowerShell using multi-factor authentication module is installed

Version 1.0
Inital release


#>



#Import-Module MSOnline
<#$SecPass = ConvertTo-SecureString "Nonstop@" -AsPlainText -Force
$O365Cred = New-Object System.Management.Automation.PSCredential ("iditb@hmc.co.il", $SecPass)
$O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session
Connect-MsolService -Credential $O365Cred#>


$path = Resolve-Path ~\desktop
$file = '\Search_Results.csv'
$fullpath = Join-Path -path $path -ChildPath $file
$str001 = "Remove Malicious Emails Ver 1.1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '894,476'
$Form.text                       = $str001
$Form.TopMost                    = $false

$EmailAddress                    = New-Object system.Windows.Forms.Label
$EmailAddress.text               = "Sender Email Address"
$EmailAddress.AutoSize           = $true
$EmailAddress.width              = 25
$EmailAddress.height             = 10
$EmailAddress.location           = New-Object System.Drawing.Point(20,31)
$EmailAddress.Font               = 'Microsoft Sans Serif,10'

$EmailAddressTextBox             = New-Object system.Windows.Forms.TextBox
$EmailAddressTextBox.multiline   = $false
$EmailAddressTextBox.width       = 600
$EmailAddressTextBox.height      = 20
$EmailAddressTextBox.location    = New-Object System.Drawing.Point(200,29)
$EmailAddressTextBox.Font        = 'Microsoft Sans Serif,10'

$Subject                         = New-Object system.Windows.Forms.Label
$Subject.text                    = "Message Subject"
$Subject.AutoSize                = $true
$Subject.width                   = 25
$Subject.height                  = 10
$Subject.location                = New-Object System.Drawing.Point(20,77)
$Subject.Font                    = 'Microsoft Sans Serif,10'

$SubjectTxtbox                   = New-Object system.Windows.Forms.TextBox
$SubjectTxtbox.multiline         = $false
$SubjectTxtbox.width             = 600
$SubjectTxtbox.height            = 20
$SubjectTxtbox.location          = New-Object System.Drawing.Point(200,75)
$SubjectTxtbox.Font              = 'Microsoft Sans Serif,10'

$Days                            = New-Object system.Windows.Forms.Label
$Days.text                       = "Days To Search"
$Days.AutoSize                   = $true
$Days.width                      = 25
$Days.height                     = 10
$Days.location                   = New-Object System.Drawing.Point(20,121)
$Days.Font                       = 'Microsoft Sans Serif,10'

$DaysTextBox                     = New-Object system.Windows.Forms.TextBox
$DaysTextBox.multiline           = $false
$DaysTextBox.width               = 60
$DaysTextBox.height              = 20
$DaysTextBox.location            = New-Object System.Drawing.Point(200,119)
$DaysTextBox.Font                = 'Microsoft Sans Serif,10'

$Message                         = New-Object system.Windows.Forms.Label
$Message.text                    = "Results"
$Message.AutoSize                = $true
$Message.width                   = 25
$Message.height                  = 10
$Message.location                = New-Object System.Drawing.Point(20,191)
$Message.Font                    = 'Microsoft Sans Serif,10'

$result                          = New-Object system.Windows.Forms.TextBox
$result.multiline                = $true
$result.width                    = 600
$result.height                   = 80
$result.location                 = New-Object System.Drawing.Point(200,167)
$result.BackColor                = [System.Drawing.Color]::FromArgb(245,245,220) #, 192)
$result.text                     = "Welcome to " +$str001
$result.Font                     = 'Microsoft Sans Serif,10'

$MFA_AccountButton               = New-Object system.Windows.Forms.Button
$MFA_AccountButton.text          = "Connect with MFA Account"
$MFA_AccountButton.width         = 200
$MFA_AccountButton.height        = 30
$MFA_AccountButton.location      = New-Object System.Drawing.Point(270,270)
$MFA_AccountButton.Font          = 'Microsoft Sans Serif,10'

$NonMFA_AccountButton            = New-Object system.Windows.Forms.Button
$NonMFA_AccountButton.text       = "Connect without MFA Account"
$NonMFA_AccountButton.width      = 200
$NonMFA_AccountButton.height     = 30
$NonMFA_AccountButton.location   = New-Object System.Drawing.Point(540,270)
$NonMFA_AccountButton.Font       = 'Microsoft Sans Serif,10'

$Status                          = New-Object system.Windows.Forms.Label
$Status.text                     = "Connection Status:"
$Status.AutoSize                 = $true
$Status.width                    = 25
$Status.height                   = 10
$Status.location                 = New-Object System.Drawing.Point(360,325)
$Status.Font                     = 'Microsoft Sans Serif,10'

$StatusUpdate                    = New-Object system.Windows.Forms.Label
$StatusUpdate.ForeColor          = 'Red'
$StatusUpdate.Text               = "Not Connected to Exchange"
$StatusUpdate.AutoSize           = $true
$StatusUpdate.width              = 25
$StatusUpdate.height             = 10
$StatusUpdate.location           = New-Object System.Drawing.Point(480,325)
$StatusUpdate.Font               = 'Microsoft Sans Serif,10'

$SearchEmail                     = New-Object system.Windows.Forms.Button
$SearchEmail.text                = "Search For The Emails"
$SearchEmail.width               = 162
$SearchEmail.height              = 60
$SearchEmail.location            = New-Object System.Drawing.Point(100,360)
$SearchEmail.Font                = 'Microsoft Sans Serif,10'

$OpenLog                         = New-Object system.Windows.Forms.Button
$OpenLog.text                    = "Open The Search Result Log File"
$OpenLog.width                   = 222
$OpenLog.height                  = 60
$OpenLog.location                = New-Object System.Drawing.Point(300,360)
$OpenLog.Font                    = 'Microsoft Sans Serif,10'

$DeleteEmails                    = New-Object system.Windows.Forms.Button
$DeleteEmails.text               = "Delete The Malicious Emails And Close"
$DeleteEmails.width              = 280
$DeleteEmails.height             = 60
$DeleteEmails.location           = New-Object System.Drawing.Point(555,360)
$DeleteEmails.Font               = 'Microsoft Sans Serif,10'

$closeButton                     = New-Object system.Windows.Forms.Button
$closeButton.text                = "Close"
$closeButton.width               = 102
$closeButton.height              = 30
$closeButton.location            = New-Object System.Drawing.Point(740,440)
$closeButton.Font                = 'Microsoft Sans Serif,10'

$MsgBoxError = [System.Windows.Forms.MessageBox]

$Form.controls.AddRange(@($EmailAddress,$EmailAddressTextBox,$Subject,$SubjectTxtbox,$Days,$DaysTextBox,$Message,$result,$MFA_AccountButton,$NonMFA_AccountButton,$Status,$StatusUpdate,$SearchEmail,$OpenLog,$DeleteEmails,$closeButton))


#region events {
$MFA_AccountButton.Add_Click({ Connect_MFA_Account })
$NonMFA_AccountButton.Add_Click({ConnectNonMFA_Account})
$SearchEmail.Add_Click({ SearchEmail })
$OpenLog.Add_Click({ OpenLog })
$DeleteEmails.Add_Click({DeleteEmails})
$closeButton.Add_Click({ closeForm })
#endregion events }

#endregion GUI }

#Search for the email on all the mailboxes
function SearchEmail()
{ 
        Try
        {
            # Check that you are connected to the 365
            Get-command Get-mailbox -ErrorAction Stop
            #Check that all the fileds are filled
                if ( $SubjectTxtbox.Text -and $EmailAddressTextBox.text -and $DaysTextBox.text )
                    {
                        # Get the Message ID
                        $EmailInfo = Get-Messagetrace -SenderAddress $EmailAddressTextBox.text -Start (Get-Date).AddDays(-$DaysTextBox.text) -EndDate(get-date)| Where-Object {$_.Subject -like $SubjectTxtbox.Text} | Select-Object RecipientAddress,status,MessageTraceID
                        #Counting the number of the emails
                        $Count = $EmailInfo |Measure-Object | Select-Object -ExpandProperty Count
                        #Export the data into excel file
                        $EmailInfo| Export-Csv $fullpath -NoTypeInformation
                        #Write the results to the result window
                        $result.text = "`r`n" +$count +" emails with the subject: " + $SubjectTxtbox.text +" were found"
                    }
                else
                    {
                        $result.text = "`r`nAll Fileds Must Contain Data"
                    }
            }
        Catch [System.SystemException]
        {
            $MsgBoxError::Show("Please login to the 365", $str001, "OK", "Error")
        }
     }

# Open the Log file
function OpenLog(){ 
    try
    {
        $objExcel = New-Object -ComObject Excel.Application
        $objExcel.Workbooks.Open($fullpath)
        $objExcel.Visible = $true
        $result.text = "`r`nThe log file can be found at " +$fullpath
    }
    Catch
    {
        $result.text = "The log file can't be found, did you search for the emails?"
    }    
}

#Delete the emails
function DeleteEmails ()
{
    $Clean = Import-Csv $fullpath
    if($Clean)
    {
    ForEach ($user in $clean.RecipientAddress)
     {
        "$" +"DeleteResults = Search-Mailbox " +$user +" -SearchQuery {subject:'" +$SubjectTxtbox.text +"' AND from:" +$EmailAddressTextBox.text +"} -DeleteContent -Force | select Identity,Success,ResultItemsCount" +"`r`n" +"$" +"DeleteResults | export-csv -append " +$path +"\DeleteResults.csv -notypeinformation" | Add-Content $path\Delete.ps1
     }
    "$" +"objDeleteLog = New-Object -ComObject Excel.Application" +"`r`n" +"$" +"objDeleteLog.Workbooks.Open("""+$path +"\DeleteResults.csv"")" +"`r`n" +"$" +"objDeleteLog.Visible =" +"$" +"true" | Add-Content $path\Delete.ps1
    "Remove-Item -Path """ +$path +"\delete.ps1"" -Force" | Add-Content $path\Delete.ps1
    invoke-expression -Command $path\Delete.ps1
    closeForm
}
else {
    $result.text = "The search results can't be found, did you search for the emails?"
}
}


Function TestConnection()
{
    Try
    {
        Get-command Get-mailbox -ErrorAction Stop
        $StatusUpdate.ForeColor = 'Green'
        $StatusUpdate.Text = "Connected to Exchange"
    }
    Catch [System.SystemException]
    {
        $StatusUpdate.ForeColor = 'Red'
        $StatusUpdate.Text = "Not Connected to Exchange"
    }
}

function Get-ExchangeOnlineModule {
    [CmdletBinding()]  
    Param(
        $ApplicationName = "Microsoft Exchange Online Powershell Module"
    )
        $InstalledApplicationNotMSI = Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall | foreach-object {Get-ItemProperty $_.PsPath}
        return $InstalledApplicationNotMSI | Where-Object { $_.displayname -match $ApplicationName } | Select-Object -First 1
    }

Function Test-ExchangeOnlineModule {
    [CmdletBinding()] 
    Param(
        $ApplicationName = "Microsoft Exchange Online Powershell Module"
    )
        return ( (Get-ExchangeOnlineModule -ApplicationName $ApplicationName) -ne $null) 
    }

 function MFA () 
    {
        if ((Test-ExchangeOnlineModule -ApplicationName "Microsoft Exchange Online Powershell Module" ) -eq $false) 
         {
            $MsgBoxError::Show('In order to connect with MFA account you need to install Exchange Online PowerShell multi-factor authentication',$str001,'Ok','Error')
        }
         else 
            {
                 try
                     {
                        $StatusUpdate.Text = "Connecting"
                        $StatusUpdate.Forecolor = 'Red'
                        Import-Module $((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | Where-Object{ $_ -notmatch "_none_" } | Select-Object -First 1)
        	            $EXOSession = New-ExoPSSession -UserPrincipalName $UPNTextBox.text
                        Import-PSSession $EXOSession -AllowClobber
                    }
                 catch
                    {
                        $MsgBoxError::Show("Wrong creds or no creds entered ...", $str001, "OK", "Error")
                    }
            }       
    }

function Non_MFA ()
    {
        try {
        $StatusUpdate.Text = "Connecting"
        $StatusUpdate.Forecolor = 'Red'
        $ExchOnlineCred = Get-Credential -ErrorAction Continue
        $ExchOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid -Credential $ExchOnlineCred -Authentication Basic -AllowRedirection -ErrorAction SilentlyContinue
        Import-PSSession $ExchOnlineSession -AllowClobber | Out-Null
        }
        catch
        {
            $MsgBoxError::Show("Wrong creds or no creds entered ...", $str001, "OK", "Error")
        }
    }

function Connect_MFA_Account ()
{
    MFA
    TestConnection
}

function ConnectNonMFA_Account ()
{
    Non_MFA
    TestConnection
}

function closeForm(){$Form.close()}

[void]$Form.ShowDialog()