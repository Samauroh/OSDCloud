<#
.SYNOPSIS
    Executes Sam's Custom OSDCloud PowerShell for USB formatting.
.DESCRIPTION
    This script performs a series of operations to configure and prepare the OSDCloud environment.
    Each section includes references to Microsoft documentation where applicable.
    During this process, there is a singular prompt; which USB drive to format.
    
    References:
    - Execution Policy:
      https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy
    - PowerShell Module Installation from the Gallery:
      https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psmodules-from-the-powershell-gallery
    - Retrieving System Information:
      https://docs.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance
    - Using Web Content in PowerShell:
      https://docs.microsoft.com/en-us/powershell/scripting/samples/using-web-content
#>

Write-Host -ForegroundColor Green "Starting Sam's Custom OSDCloud ..."
Start-Sleep -Seconds 5

# Set Execution Policy to allow running local scripts.
# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy
Set-ExecutionPolicy RemoteSigned -Force
Write-Host -ForegroundColor Green "Execution Policy set: RemoteSigned"

# Make sure the OSD PowerShell Module is installed and updated.
Write-Host -ForegroundColor Green "Installing / Updating the OSD PowerShell Module"
# Installs the module from the PowerShell Gallery.
# Reference: https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psmodules-from-the-powershell-gallery
Install-Module OSD -Force

Write-Host -ForegroundColor Green "Importing the PowerShell Module"
Import-Module OSD -Force

# Setup for Cloud Template usage.
Write-Host -ForegroundColor Green "Setting up Cloud Template"
# New-OSDCloudTemplate creates a new deployment template for OSDCloud.
New-OSDCloudTemplate

# Setup temporary cloud storage path.
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
Write-Host -ForegroundColor Green "Set Cloud Storage Path: C:\OSDCloud"

# Format the USB drive for OSDCloud use.
Write-Host -ForegroundColor Green "Formatting USB"
New-OSDCloudUSB

# Modify the base OSDCloud template.
# This command includes all CloudDrivers on the USB to address network access concerns.
# The WebPSScript parameter allows the use of dynamic web content for newer Windows versions.
# For more details on using web content in PowerShell scripts, see: https://docs.microsoft.com/en-us/powershell/scripting/samples/using-web-content
Write-Host -ForegroundColor Green "Modifying the base OSD template with Sam's Dynamic WebScript (Windows 11 Home)"
Edit-OSDCloudwinPE -workspacepath C:\OSDCloud -CloudDriver Wifi -WebPSScript https://gist.githubusercontent.com/Samauroh/37f2ddb95731335be68c49a11d13cc9b/raw/DynamicOSD.ps1 -Verbose

# Create a new ISO based on the current OSDCloud settings.
Write-Host -ForegroundColor Green "Creating New ISO"
New-OSDCloudISO

# Update the USB drive with the new settings from the modified template.
Write-Host -ForegroundColor Green "Updated USB settings from template"
Update-OSDCloudUSB
