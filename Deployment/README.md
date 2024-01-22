# Uninstall ESET Antivirus, pull from S3, and install SentinelOne

## Introduction
In one of my positions as a System Administrator, I was tasked with replacing the company's endpoint security antivirus. In this case, the antivirus to be replaced was ESET, and the new solution chosen was SentinelOne XDR. Instead of manually handling each endpoint, I decided to write a script to automate the process. In this tutorial, I will guide you through the steps of uninstalling the ESET antivirus, downloading the XDR installation from the AWS S3 Bucket, and installing it on the system.

Please note that the 'Get-Files' function can be utilized for downloading any type of data from an S3 Bucket and can serve other organizational needs.

Similarly, the 'InstallXDR' function can be easily adjusted to function as an installer for other applications.

## Requierments
