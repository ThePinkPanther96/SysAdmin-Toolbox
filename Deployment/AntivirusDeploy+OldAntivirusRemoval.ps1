<#
.SYNOPSIS
    This script automates the removal of ESET Endpoint Antivirus, downloads files from an AWS S3 bucket,
    and installs SentinelOne Agent on the target machine.

.NOTES
    File Name      : YourScriptName.ps1
    Prerequisite   : PowerShell, AWSPowerShell
    Prerequisite   : PowerShell v3 - 7
    Author         : Copyright 2024 - Gal R


.FUNCTIONALITY
 
function DeleteESET {

    .SYNOPSIS
    The DeleteESET Checks if ESET Endpoint Antivirus is installed on the system. 
    If ESET is installed, DeleteESET will attempt to uninstall it completly from the system.    

    .DESCRIPTION
    - Checks if ESET Endpoint Antivirus is installed.
    - Retrieves uninstallation information for ESET.
    - Uninstalls ESET components silently, including agents and security installations.
    - Verifies the successful uninstallation.

    .PARAMETER
    No parameters needed.

}
   
function Get-Files {

    .SYNOPSIS
    Downloads files from an AWS S3 bucket to specified target paths.

    .NOTES
    Requires elevated privileges for successful execution.

    .DESCRIPTION
    The Get-Files function downloads files from an AWS S3 bucket and checks their existence at the target paths.
    If the files already exist, it prints a message; otherwise, it downloads and verifies their deployment.
    This function for deploying the needed object from a S3 Bucket.

    .PARAMETER TargetPaths
    An array of the full target path including the objects names, where the files should be deployed.
    It is important to specify the full target path including the precise name of the object as it appears in the deployment bucket.
    
    .PARAMETER SecretKey
    The AWS IAM User Secret Acsses key.

    .PARAMETER Key
    The AWS IAM User Acsses key.

    .PARAMETER BucketName
    The name of the AWS S3 bucket.
}

function InstallXDR {

    .SYNOPSIS
    Installs SentinelOne Agent on the system.

    .NOTES
    Requires elevated privileges for successful execution.

    .DESCRIPTION
    - Checks if SentinelOne Agent is installed.
    - Installs using the provided installer path and site token.
    - Verifies installation success.

    .PARAMETER installerPath
    The path to the SentinelOne Agent installer.

    .PARAMETER sitToken
    SentinelOne API Token.
    
    .EXAMPLE
    InstallXDR -installerPath "C:\Installer\SentinelOneInstaller.exe"
    # Installs SentinelOne Agent.

}

.EXAMPLE
$Paths is a list of the deployment destinations on the local machine. 
To deploy correctly, you must specify the path for deployment, 
as well as the precise names of the objects as they are named in the deployment S3 Bucket
See example:

$Paths = @("C:\Windows\Temp\SentinelOneInstaller_windows_64bit_v22_3_5_887.exe")

Example for executing the script:

if ($MyInvocation.CommandOrigin -eq 'Runspace'){
    DeleteESET
    
    Get-Files -TargetPaths $Paths `
        -BucketNmae "bucket" `
        -Key "hvhgHG787JF%67g$^" `
        -SecretKey "&^6$%$#^&V%^$c%4^5C8&b87^O7V" `
    
    InstallXDR -installerPath $Paths `
        -siteToken "V%^$c%4^87JF%6HJGJ8&65*&6*" # Insert SentinelOne API token.

#>


function DeleteESET {
    write-host "Getting ESET ready..."
    $esetInstances = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "ESET Endpoint Antivirus"}
    if ($esetInstances.Count -eq 0) {
        Write-Host "ESET not installed" -ForegroundColor "Red"
        return;
    }
    else {
        $Items=(Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match "ESET" } | Select-Object -Property DisplayName,UninstallString)
        ForEach ($item in $Items){
            if ($null -ne $item.UninstallString) {
                $id=$item.UninstallString.Replace("MsiExec.exe /I","")
                $name=$item.DisplayName
                if($name -like "*Agent*"){
                    Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $id /qn /norestart PASSWORD=`PASSWORD` " -Wait # Replace 'PASSWORD' with the ESET uninstall password.
                } else {
                    Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $id /qn /norestart PASSWORD=`PASSWORD` " -Wait # Replace 'PASSWORD' with the ESET uninstall password.
                }
            }
        }
        Write-Host "Uninstalling ESET..."
        msiexec /x "C:\ProgramData\ESET\RemoteAdministrator\Agent\SetupData\Installer\Agent_x64.msi" /qn /norestart
        msiexec /x "C:\ProgramData\ESET\ESET Security\Installer\ees_nt64.msi" /qn /norestart
        msiexec /x "C:\ProgramData\ESET\ESET Security\Installer\eav_nt64.msi" /qn /norestart
        
        $esetInstancesAfter = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "ESET Endpoint Antivirus"}
        if ($esetInstancesAfter.Count -eq 0) {
            Write-Host "ESET uninstalled successfully." -ForegroundColor "Green"
            return;
        }
        else {
            Write-Host "Failed to uninstall ESET: $_" -ForegroundColor "Red"
            break
        }
    }
}

function Get-Files {
    param (
        [string[]]$TargetPaths,
        [string]$SecretKey,
        [string]$Key,
        [string]$BucketName
    )
    foreach ($Path in $TargetPaths) {
        if (Test-Path -Path $Path) {
            Write-Host "$Path Already Exists!" -ForegroundColor "Gray"
        }
        else {
            Import-Module -Name AWSPowerShell
            $credentials = New-Object Amazon.Runtime.BasicAWSCredentials -ArgumentList $Key, $SecretKey
            $Object = [System.IO.Path]::GetFileName($Path)
            Write-Host "Downloading files to $Path ..." -ForegroundColor "Yellow"
            Read-S3Object -BucketName $BucketName -Key $Object -File $Path -Credential $credentials
            if (Test-Path -Path $TargetPaths) {
                Write-Host "$Object deployed successfully" -ForegroundColor "Green"
            }
            else {
                Write-Host "$Object was not deployed!" -ForegroundColor "Red"
            }
        }
    }
}

function InstallXDR {
    param (
        [string]$installerPath,
        [string]$siteToken
    )
    $SentinelInstances = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Sentinel Agent*"}
    if ($SentinelInstances) {
        Write-Host "SentinelOneAgent already installed." -ForegroundColor "Yellow"
        Break
    }
    else {
        try {
            Write-Host "Installing SentinelOne..."
            $arguments = "-t", "$siteToken", "-q"
            Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait
            $SentinelInstances = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "Sentinel Agent"}
            if ($SentinelInstances) {
                Write-Host "Installation was a success!" -ForegroundColor "Green"
            }
            else {
                Write-Host "Istallation failed: $_" -ForegroundColor "Red"
            }
        }
        catch {
            Write-Host "Istallation failed: $_" -ForegroundColor "Red"
        }   
    }    
}

Write-Host "Starting script..." -ForegroundColor "Yellow"

$Paths = @("C:\Windows\Temp\SentinelOneInstaller_windows_64bit_v22_3_5_887.exe")

if ($MyInvocation.CommandOrigin -eq 'Runspace'){
    DeleteESET
    
    Get-Files -TargetPaths $Paths `
        -BucketNmae "BUCKET NAME" `
        -Key "KEY" `
        -SecretKey "SECRET KEY" `
    
    InstallXDR -installerPath $Paths `
        -siteToken "API_TOKEN" # Insert SentinelOne API token.
}

