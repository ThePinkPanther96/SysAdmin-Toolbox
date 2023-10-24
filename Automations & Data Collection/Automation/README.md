# Introduction
In this tutorial, I will guide you through a series of automation scripts in this repository. All of the scripts were used in an organizational production environment. Each of them was used to automate and streamline IT operations, including software deployment, monitoring, and deployment. By dedicating the time and effort to write these scripts, I was able to save a significant amount of time and reduce manual work for both myself and my team. So, let's get started!

# List of scripts
- [Enable_Bitlocker+Recovry_Key.ps1](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/Enable_Bitlocker%2BRecovry_Key.ps1)
- [PING_CONPUTER.ps1](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/PING_CONPUTER.ps1)
- [Disk_monitoring.py](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/Disk_monitoring.py)

## [Enable_Bitlocker+Recovry_Key.ps1](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Automations%20%26%20Data%20Collection/Automation/Enable_Bitlocker%2BRecovry_Key.ps1)
This script is as simple as it gets. It's divided into three functions: 
- Enable BitLocker: This function checks if BitLocker is currently disabled on the "C:" drive (Or any other drive for that matter). If it's disabled, it activates BitLocker on the drive with certain settings. After enabling BitLocker, it resumes BitLocker on the specified drive.
It can also be extended to other drives as shown in this code block:
 ```ps1
  Enable-BitLocker -MountPoint "C:" -SkipHardwareTest -RecoveryPasswordProtector
  Resume-BitLocker -MountPoint "C:"
  # Add another MountPoint here. Follow the example:
  # Enable-BitLocker -MountPoint "D:" -SkipHardwareTest -RecoveryPasswordProtector
  # Resume-BitLocker -MountPoint "D:"
 ```
