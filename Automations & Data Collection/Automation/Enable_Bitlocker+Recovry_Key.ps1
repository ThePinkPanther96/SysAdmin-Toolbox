function Enable-Bitlocker {
  $bitlockerVolume = Get-BitLockerVolume -MountPoint "C:"
  if ($bitlockerVolume.ProtectionStatus -eq 'Off') {
    try {
      Write-Host "BitLocker is disabled on this PC" -ForegroundColor "Red"
      Import-Module "Bitlocker"
      Write-Host "Activating BitLocker..." -ForegroundColor "Yellow"
      Enable-BitLocker -MountPoint "C:" -SkipHardwareTest -RecoveryPasswordProtector
      Resume-BitLocker -MountPoint "C:"
      # Add another MountPoint here. Follow the example:
      # Enable-BitLocker -MountPoint "D:" -SkipHardwareTest -RecoveryPasswordProtector
      # Resume-BitLocker -MountPoint "D:"
      Write-Host "BitLocker was activated successfully" -ForegroundColor "Green"
    }
    catch {
      Write-Host "Error: $_" -ForegroundColor "RED" -BackgroundColor "DarkRed"
    }  
  }
  else {
    Write-Host "BitLocker already enabled" -ForegroundColor "Yellow"
    return;
  }   
}

function Get-BitLockerRecoveryKey {
  try {
    Write-Host "Getting BitLocker Recovery Key..." -ForegroundColor "Yellow"
    $BitLockerInfo = Get-BitLockerVolume

    $RecoveryKeys = foreach ($Volume in $BitLockerInfo) {
      $ComputerName = $env:COMPUTERNAME
      $RecoveryKeys = $Volume.KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'} | Select-Object -ExpandProperty RecoveryPassword
      if ($RecoveryKeys -is [System.Object[]]) {
        foreach ($key in $RecoveryKeys) {
          [PSCustomObject]@{
            ComputerName = $ComputerName
            RecoveryKey = $key
          }
        }
      } 
      else {
        [PSCustomObject]@{
          ComputerName = $ComputerName
          RecoveryKey = $RecoveryKeys
        }
      }
    }
    Write-Host "BitLocker Recovery Key retrieved!" -ForegroundColor "Green"
  }
  catch {
    Write-Host "Error: $_" -ForegroundColor "RED" -BackgroundColor "DarkRed"
  }

  return $RecoveryKeys
}

function Export-BitLockerRecoveryKeyToCSV {
  
  $Date = Get-Date -Format "dd-MM-yyyy"
  $FileName = "BitLockerRecoveryKey_$Date.csv"
  $OutputPath = "\\192.168.1.10\newpublic\$FileName"

  $BitLockerInfo = Get-BitLockerRecoveryKey

  if ($null -eq $BitLockerInfo) {
    Write-Host "No BitLocker Recovery Key Was Found!" -ForegroundColor "RED" -BackgroundColor "DarkRed"
  } 
  else {
    Write-Host "Exporting Bitlocker Recovery Key..." -ForegroundColor "Yellow"
    try {
      if (-not (Test-Path $OutputPath)) {
        Write-Host "No file found for this date. Creating new CSV file." -ForegroundColor "Yellow"
        # If the file doesn't exist, create it with the header
        $BitLockerInfo | Export-Csv -Path $OutputPath -NoTypeInformation
      } 
      else {
        Write-Host "Exporting Data to $FileName"
        # Append the new entries to the existing file
        $BitLockerInfo | Export-Csv -Path $OutputPath -NoTypeInformation -Append
      }  
      Write-Host "BitLocker recovery keys exported successfully to $FileName!" -ForegroundColor "Green"
    }
    catch {
      Write-Host "Error: $_" -ForegroundColor "RED" -BackgroundColor "DarkRed"
    }
  }
}

Write-Host "Starting script..." -ForegroundColor "Yellow"

if ($MyInvocation.CommandOrigin -eq 'Runspace'){
  Enable-Bitlocker
  Get-BitLockerRecoveryKey
  Export-BitLockerRecoveryKeyToCSV
}
