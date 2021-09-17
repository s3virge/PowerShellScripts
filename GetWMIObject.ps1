# Get-WmiObject -List

# pause

Get-WMIObject -Class Win32_NetworkAdapter
Get-WMIObject -Class Win32_NetworkAdapterConfiguration
Get-WMIObject -Class Win32_DiskDrive
Get-WMIObject -Class Win32_LogicalDisk
Get-WMIObject -Class Win32_Baseboard 

$PSVersionTable
# Get-ADUser –Identity "v.kobzar" –Properties *
# Get-ADUser –Identity v.kobzar –Properties Mail
# Get-ADUser –Identity v.kobzar –Properties * | Export-CSV -Path 'D:\kobzarAd.csv'
# Get-Service | ConvertTo-HTML -Property Name, Status > d:\services.htm
# get-alias | convertto-html > aliases.htm

Get-CimInstance -ClassName Win32_BIOS <# -ComputerName . #>

Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName . <# | Select-Object -Property BuildNumber,BuildType,OSType,ServicePackMajorVersion,ServicePackMinorVersion #>