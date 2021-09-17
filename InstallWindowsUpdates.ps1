<# 
    https://www.urtech.ca/2017/07/solved-simple-powershell-script-download-install-windows-updates-reboot-necessary/

    https://www.powershellgallery.com/packages/PSWindowsUpdate/2.1.1.2
#>

# By Ian Matthews with the help of many
# Last Updated July 28 2017

# Requires PowerShell 5.0 or newer
# Apparently NUGET is required for the PSWINDOWSUPDATE module
#Install-PackageProvider NuGet -Force
#Import-PackageProvider NuGet -Force


# Apparentely PSWindowsUpdate module comes from the PSGallery and needs to be trusted
# See https://msdn.microsoft.com/en-us/powershell/gallery/psgallery/psgallery_gettingstarted
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted


# Now actually do the update and reboot if necessary
Install-Module -Name PSWindowsUpdate

Get-Command –module PSWindowsUpdate

Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false

Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot