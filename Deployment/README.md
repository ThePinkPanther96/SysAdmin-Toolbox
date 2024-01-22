# Uninstall ESET Antivirus, pull from S3, and install SentinelOne

## Introduction
In one of my positions as a System Administrator, I was tasked with replacing the company's endpoint security antivirus. In this case, the antivirus to be replaced was ESET, and the new solution chosen was SentinelOne XDR. Instead of manually handling each endpoint, I decided to write a script to automate the process. In this tutorial, I will guide you through the steps of uninstalling the ESET antivirus, downloading the XDR installation from the AWS S3 Bucket, and installing it on the system.

Please note that the 'Get-Files' function can be utilized for downloading any type of data from an S3 Bucket and can serve other organizational needs.

Similarly, the 'InstallXDR' function can be easily adjusted to function as an installer for other applications.

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

## Execute the script
