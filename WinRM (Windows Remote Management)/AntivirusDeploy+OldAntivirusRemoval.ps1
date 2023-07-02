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

function PullData {
    $awspath = 'https://BUCKET_NAME.s3.eu-central-1.amazonaws.com/SentinelOneInstaller_windows_64bit_v22_3_5_887.exe' # Replace URL with S3 Bucket + the installation file URL.
    $targetdir =  'C:\Windows\Temp\SentinelOneInstaller_windows_64bit_v22_3_5_887.exe'
    if (Test-Path $targetdir) {
        write-host "SentinelOne Agent already in target directory" -ForegroundColor "Yellow" 
        return;
    }
    else {
        try {
            Write-Host "Starting download...."  -ForegroundColor "Yellow"
            Invoke-WebRequest -Uri $awspath -OutFile $targetdir
            if (Test-Path $targetdir) {
                Write-Host "Download was a success!" -ForegroundColor "Green"
            }
            else {
                Write-Host "Could not pull data: $_" -ForegroundColor "Red"
                break
            } 
        }
        catch {
            Write-Host "Could not pull data: $_" -ForegroundColor "Red"
            break
        }
    }
    
}

function InstallXDR {
    $SentinelInstances = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Sentinel Agent*"}
    if ($SentinelInstances) {
        Write-Host "SentinelOneAgent already installed." -ForegroundColor "Yellow"
        Break
    }
    else {
        try {
            Write-Host "Installing SentinelOne..."
            $installerPath = "C:\Windows\Temp\SentinelOneInstaller_windows_64bit_v22_3_5_887.exe"
            $siteToken = "API_TOKEN" # Insert SentinelOne API token.
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

if ($MyInvocation.CommandOrigin -eq 'Runspace'){
    DeleteESET
    PullData
    InstallXDR
}

