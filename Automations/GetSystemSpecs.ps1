# Get computer information
# Get CPU
$cpu = (Get-WmiObject Win32_Processor).Name

# Get Memory
$memory = [math]::Round((Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)

# Get OS
$os = (Get-WmiObject Win32_OperatingSystem).Caption

# Get storage compacity
$storage = Get-WmiObject Win32_DiskDrive | ForEach-Object { "$($_.Model) $([math]::Round($_.Size / 1GB))GB $($_.InterfaceType)" }

# Get GPU
$gpu = (Get-WmiObject Win32_VideoController).Caption

# Get (all) network adapters
$networkAdapters = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true }

# Get serial number
$serialNumber = (Get-WmiObject Win32_BIOS).SerialNumber

# Get computer model 
$computerModel = (Get-WmiObject Win32_ComputerSystem).Model

# Get vendor name
$vendorName = (Get-WmiObject Win32_ComputerSystem).Manufacturer

# Create the output string for network adapters
$networkOutput = "Network Adapters and Drivers:`n"
foreach ($adapter in $networkAdapters) {
    $adapterName = $adapter.Name
    $driver = (Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceName -eq $adapterName }).DriverVersion
    $networkOutput += "$adapterName (Driver: $driver)`n"
}

# Create the output string
$output = @"
System Specifications:
--------------------------------------------
CPU: 

$cpu
--------------------------------------------
Memory: 

$memory GB DDR4
--------------------------------------------
OS:

$os
--------------------------------------------
Storage: 
`n$($storage -join "`n")
--------------------------------------------
GPU:
`n$gpu`n
--------------------------------------------
Network Adapters:

$networkOutput
--------------------------------------------

Vendor: 

$vendorName
--------------------------------------------
#Serial Number: 

$serialNumber
--------------------------------------------
Computer Model: 

$computerModel
--------------------------------------------

"@
# Determine the user's Downloads folder path
$downloadsPath = [Environment]::GetFolderPath("User") + "\Downloads"

# Create the SystemSpec.txt file in the Downloads folder
$output | Set-Content -Path "$downloadsPath\SystemSpec.txt"

Write-Host "System information has been saved to: $downloadsPath\SystemSpec.txt"
