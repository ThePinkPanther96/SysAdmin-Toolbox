# WinRM Configuration
## Introduction
In this tutorial, I will guide you through the process of configuring WinRM (Windows Remote Management) in an Active Directory domain environment, as well as demonstrate mass software deployment with an easy-to-use PowerShell automation script. WinRM is a powerful tool that enables remote management and automation of Windows-based systems. Its primary benefits include secure remote access to Windows machines, streamlined administration, and the ability to execute scripts and commands remotely, facilitating efficient system management in a networked environment. WinRM has helped me manage my domain environment and saved me hours of manual work. So let's get started!


## Requirement
- Working in Active Directory environment.
- Windows-based endpoints connected to an organizational network.
- Basic understanding of PowerShell.
- Basic understanding of network protocols.


## Configuration
1. Enter Group Policy Management
2. Under Group Policy Objects OU create a new policy object.

### Allow remote server management through WinRM
1. Navigate to Computer Configuration > Policies > Administrative Templates: Policy definitions > Windows Components > Windows Remote Management (WinRM) > WinRM Service
2. Right-click on Allow remote server management through WinRM and click Edit	
3. Select Enabled to allow remote server management through WinRM

### Enable remote server management service:
1. Navigate to  Computer Configuration > Preferences > Control Panel Settings > Services
2. Right-click on Services and select New > Service
3. Select Automatic as the startup
4. Under Service Name: Select WinRM 
5. Select Start service as the service action

### Allow for inbound remote administration by updating the firewall rules:
1. Navigate to Computer Configuration > Policies > Administrative Templates: Policy definitions > Network > Network Connections > Windows Firewall > Domain Profile
2. Enable the following policies: 
	  ○ Windows Firewall: Allow inbound remote administration exception	
	  ○ Windows Firewall: Allow ICMP exception

### Create  new inbound firewall rules:
1. Navigate to Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advanced Security > Windows Firewall with Advanced Security > Inbound Rules
2. Create the following inbound rule:
	  ○ Name: WinRM
	  ○ Ports: 80, 443, 5985, 5956
		○ Protocol: TCP
3. Navigate to Computer Configuration > Policies > Windows Settings > Security Settings > Network List Manager Policies
4. Right-click Unidentified Networks and click Properties

### Link the policy:
1. Navigate to the correct OU under the domain tree
2. Right-click on the selected OU and select Link existing GPO…
3. Select the GPO 

### Automation
In this part, I'll explain how to use the attached PowerShell script to utilize WinRM on a large organizational scale.
https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/WinRM%20(Windows%20Remote%20Management)/MassDeploymentScript.ps1

The script's main purpose is to automate the execution of a PowerShell script on a list of remote endpoints (computers) specified in the $endpoints array. It does this by establishing remote PowerShell sessions with each endpoint and running the specified script located at $scriptPath on each remote machine.

- Utilize the $scriptPath variable to specify the location of the PowerShell script file you wish to execute remotely. This script can serve various purposes such as deploying software, collecting data, enforcing policies, etc.
  
```nh
# Define the path to the PowerShell script file on the local machine
$scriptPath = "C:\Path\To\Deployment\Script" # Place here the script to execute.
```

- Is an array that contains the names of the target remote computers where you want to execute the script. You can add or remove computer names from this list as needed. The script iterates through this list and executes the script on each computer.

```nh
# Define the list of target endpoints
$endpoints = @(
    "COMPUTER-1","COMPUTER-2","COMPUTER-3","COMPUTER-4",
    "COMPUTER-5","COMPUTER-6","COMPUTER-7","COMPUTER-8",
    "COMPUTER-9","AND-SO-ON","AND-SO-ON"
)
```


