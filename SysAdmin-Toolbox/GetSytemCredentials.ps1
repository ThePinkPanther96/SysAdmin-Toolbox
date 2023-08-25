# Get CPU Type
$cpuType = (Get-WmiObject Win32_Processor).Name

# Get Storage Capacity
$drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
$storageCapacity = $drives | Measure-Object Size -Sum | % { $_.Sum / 1GB }

# Get Storage Usage
$storageUsage = $drives | Measure-Object FreeSpace -Sum | % { $_.Sum / 1GB }

# Get Memory Capacity
$memoryCapacity = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB

# Get Network Adapter(s)
$networkAdapters = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true } | Select-Object Name

# Get Windows Type
$windowsType = (Get-WmiObject Win32_OperatingSystem).Caption

# Get Hostname
$hostname = $env:COMPUTERNAME

# Get MAC Address
$macAddress = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true } | Select-Object MACAddress

# Get Serial Number
$serialNumber = (Get-WmiObject Win32_BIOS).SerialNumber

# Get Computer Model
$computerModel = (Get-WmiObject Win32_ComputerSystem).Model

# Get Vendor Name
$vendorName = (Get-WmiObject Win32_ComputerSystem).Manufacturer

# Get Last Windows/Security Update
$update = Get-WmiObject -Query "SELECT * FROM Win32_QuickFixEngineering WHERE HotFixID LIKE 'KB%' AND InstalledOn IS NOT NULL" | Sort-Object InstalledOn -Descending | Select-Object -First 1

$lastUpdate = if ($update) { $update.InstalledOn } else { "N/A" }
$lastUpdateKB = if ($update) { $update.HotFixID } else { "N/A" }

# Get External GPU (If any)
$externalGPU = Get-WmiObject Win32_VideoController | Where-Object { $_.AdapterRAM -gt 0 } | Select-Object Name

# Create an object to hold the information
$systemInfo = [PSCustomObject] @{
    "CPU Type" = $cpuType
    "Storage Capacity (GB)" = $storageCapacity
    "Storage Usage (GB)" = $storageUsage
    "Memory Capacity (GB)" = $memoryCapacity
    "Windows Type" = $windowsType
    "Hostname" = $hostname
    "MAC Address" = $macAddress.MACAddress
    "Serial Number" = $serialNumber
    "Computer Model" = $computerModel
    "Vendor Name" = $vendorName
    "Last Windows/Security Update" = $lastUpdate
    "Last Update KB" = $lastUpdateKB
    "External GPU" = $externalGPU.Name
    "Network Adapter(s)" = $networkAdapters.Name -join ", `n"
}

# Determine the user's Downloads folder path
$downloadsPath = [Environment]::GetFolderPath("User") + "\Downloads"

# Save the data to a text file
$filePath = Join-Path -Path $downloadsPath -ChildPath "system_Credentials.txt"
$systemInfo | Out-File -FilePath $filePath

# Display the saved file path
Write-Host "System information saved to: $filePath"
