# Get Exchange Backup Alerts
## Introduction
The purpose of this script is to check the backup timestamps for the servers and generate alerts if a database hasn't been backed up recently. No inputs are required. However, you should modify the [Settings.xml](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Office365/Exchange-Backup-Alerts/Settings.xml) file to customize it for your environment.

## Requirements
- Access to an Exchange Online Environment.
- PowerShell 5 or higher.
- Exchange Online PowerShell Module
- Valid credentials for connecting to Exchange Online.

## Output
The script will send an HTML email if it detects databases that haven't been backed up for more than the specified number of hours.

## Examples
```
.\Get-DailyBackupAlerts.ps1 
```
Tip: Run as a scheduled task to generate the alerts automatically

Sends the report even if no alerts are found, and writes a log file.
```
.\Get-DailyBackupAlerts.ps1 -AlwaysSend -Log
```

## Configuration
Modify these alert thresholds in [Settings.xml](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Office365/Exchange-Backup-Alerts/Settings.xml) to set a different alert threshold. 
You can also configure a different alert threshold for Mondays to account for weekend backup schedules:
```
  <OtherSettings>
    <ThresholdMonday>48</ThresholdMonday>
    <ThresholdOther>24</ThresholdOther>
  </OtherSettings>
```

If you want to exclude databases add them to the [Settings.xml](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Office365/Exchange-Backup-Alerts/Settings.xml) file:
Code:
```
$exclusions = @($ConfigFile.Settings.Exclusions.DBName)

foreach ($dbname in $exclusions)
{
    $excludedbs += $dbname
}
```
[Settings.xml](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Office365/Exchange-Backup-Alerts/Settings.xml):
```
  <Exclusions>
    <DBName></DBName>
    <DBName></DBName>
  </Exclusions>
```








