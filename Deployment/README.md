# Uninstall ESET Antivirus, pull from S3, and install SentinelOne

## Introduction
In one of my positions as a System Administrator, I was tasked with replacing the company's endpoint security antivirus. In this case, the antivirus to be replaced was ESET, and the new solution chosen was SentinelOne XDR. Instead of manually handling each endpoint, I decided to write a script to automate the process. In this tutorial, I will guide you through the steps of uninstalling the ESET antivirus, downloading the XDR installation from the AWS S3 Bucket, and installing it on the system.

**Please note that the 'Get-Files' function can be utilized for downloading any type of data from an S3 Bucket and implemented into different scripts and serve other organizational needs.**

**Similarly, the 'InstallXDR' function can be easily adjusted to function as an installer for other applications.**

## Requirements
- Active AWS account with administrative privileges.
- PowerShell Module: AWSPowerShell.
- Basic understanding of PowerShell.
- Windows 10 client.

## AWS Configuration - S3 Bucket and IAM Resources 
In this section, we will configure a new S3 Bucket with the correct permissions, an IAM user, and an IAM group that will be used to interact with the bucket.

### Create Bucket
1. Navigate to **"S3" > "Create bucket"**
2. Name the Bucket.
3. Under **"Block Public Access settings for this bucket"** make sure that it is set to **"Block all public access"**
4. Under **"Default Encryption"** make sure that it is set on **"Server-side encryption with Amazon S3 managed keys"**
5. Click on **"Create bucket"**

### Create IAM user group
2. Navigate to **IAM > User groups > Create group** (I named my group "s3-readonly" so it will be easily recognizable).
3. Navigate to the newly created **IAM group > Permissions > Add permissions > Create inline policy > JSON**
4. Clear the text editor and paste the content of [**Permissions.json**](https://github.com/ThePinkPanther96/SysAdmin-Toolbox/blob/main/Deployment/Permissions.json) After editing the file according to your configuration layout (see instructions in the JSON file).
5. Click on **"Review policy"** and you are done with the group for now.

### Create IAM user
1. Navigate to **IAM > Users > Add users** 
2. Name the new user (I named my group "bucket-admin" so it will be easily recognizable).
3. Select **"Add user to group" > select the group that you created previously > click "Next"**
4. Under **"Key"** write **"Name"** and under Value Write the name of the new **IAM user > click "Next"**
5. Review the user settings and click **"Create user"**
6. Enter the new user > navigate to **"Security credentials"** > scroll down and click on **Create access key**
7. Save both **Access key** and **Secret Access Key**. They will be used later.

## About the script
The script is structured with three distinct functions, each serving a specific purpose. 
### DeleteESET
This function performs the following tasks:
- Checks if ESET Endpoint Antivirus is installed.
- Retrieves uninstallation information for ESET.
- Uninstall ESET components silently, including agents and security installations.
- Verifies the successful uninstallation.
### Get-Files
- The Get-Files function downloads files from an AWS S3 bucket and checks their existence at the target paths.
  If the files already exist, it prints a message; otherwise, it downloads and verifies their deployment.
  This function is for deploying the needed object from a S3 Bucket.
### InstallXDR
This function is responsible for the following operations:
- Checks if SentinelOne Agent is installed.
- Installs using the provided installer path and site token.
- Verifies installation success.

By executing these functions, the script effectively manages the uninstallation of ESET, facilitates the deployment of required files from an S3 bucket, and ensures the installation of the SentinelOne Agent, thereby contributing to the overall security and integrity of the system.

## Executing the script
Open the script and scroll down to the end of the script. 

### $Paths
is a list of the deployment destinations on the local machine. 
To deploy correctly, you must specify the path for deployment, 
as well as the precise names of the objects as they are named in the deployment S3 Bucket
See example:

```$Paths = @("C:\Windows\Temp\SentinelOneInstaller_windows_64bit_v22_3_5_887.exe")```

### Function DeleteESET
Nothing to do here. 

### Function Get-Files
- Replace **"BUCKET NAME"** with the name of the deployment bucket.
- Replace **"KEY"** with  the IAM user Access Key.
- Replace **SECRET KEY** with the IAM user Secret Access Key.

  See example:
  ```Get-Files -TargetPaths $Paths -BucketNmae "BUCKET NAME" -Key "KEY" -SecretKey "SECRET KEY" ```

### Function InstallXDR
- Replace **"API_TOKEN"** with the SentinelOne API Token.

  See example:
  ```InstallXDR -installerPath $Paths -siteToken "API_TOKEN"```

  
