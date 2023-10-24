# Introduction
In this tutorial, I will guide you through a series of automation scripts in this repository. All of the scripts were used in an organizational production environment. Each of them was used to automate and streamline IT operations, including software deployment, monitoring, and deployment. By dedicating the time and effort to write these scripts, I was able to save a significant amount of time and reduce manual work for both myself and my team. So, let's get started!

# List of scripts
- [Enable_Bitlocker+Recovry_Key.ps1](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/Enable_Bitlocker%2BRecovry_Key.ps1)
- [PING_CONPUTER.ps1](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/PING_CONPUTER.ps1)
- [Disk_monitoring.py](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/Disk_monitoring.py)

## Enable_BitlockerRecovry_Key.ps1
This script is as simple as it gets. It's divided into three functions: 
- Enable BitLocker: This function checks if BitLocker is currently disabled on the "C:" drive (Or any other drive for that matter). If it's disabled, it activates BitLocker on the drive with certain settings. After enabling BitLocker, it resumes BitLocker on the specified drive:
It can also be extended to other drives as shown in this code block:
  ```ps1
   Enable-BitLocker -MountPoint "C:" -SkipHardwareTest -RecoveryPasswordProtector
   Resume-BitLocker -MountPoint "C:"
   # Add another MountPoint here. Follow the example:
   # Enable-BitLocker -MountPoint "D:" -SkipHardwareTest -RecoveryPasswordProtector
   # Resume-BitLocker -MountPoint "D:"
  ```

- Get BitLocker Recovery Key: This function retrieves the BitLocker recovery keys for the computer. It collects recovery keys for all BitLocker-protected volumes and organizes them into a data structure:
  ```ps1
  foreach ($key in $RecoveryKeys) {
          [PSCustomObject]@{
            ComputerName = $ComputerName
            RecoveryKey = $key
          }
        }
  ```
  The recovery keys are used in case a user forgets their BitLocker password and needs to recover data.

- Export BitLocker Recovery Key to CSV: This function exports the BitLocker recovery keys obtained in the previous step to a CSV file. It includes the computer name and recovery key information. If the CSV file for the current date doesn't exist, it creates a new file. If it already exists, it appends the new entries to the existing file.
You can customize the *$FileName* and *$OutputPath* in this code block:
  ```ps1
  $Date = Get-Date -Format "dd-MM-yyyy"
  $FileName = "BitLockerRecoveryKey_$Date.csv"
  $OutputPath = "\\IP\Hostname\Storage\$FileName"
  ```

  ## PING_CONPUTER.ps1
