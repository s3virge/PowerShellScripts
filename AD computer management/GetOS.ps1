
function Start-PSAdmin {
	Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
}

function IsUserAdmin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  return $boolResult
}

#если юзер не админ, то запускаемся с повышенными привелегиями
if ((IsUserAdmin) -eq $false) {
	Start-PSAdmin
	exit
}

#In PowerShell 3.0 you can get it with the new $PSScriptRoot variable,
# and with $PSCommandPath you can get the full script path.

#Step 1. Open PowerShell with elevated privileges.
$computer = read-host "Enter computer name"

# $computers = "vnuchenko2"
# $FilePath = 'd:\' + $computer + '_OS.csv'

#Step 2. To check operating system name.
#(Get-WMIObject win32_operatingsystem -computer $computer).name

#Step 3. To check if the operating system is 32-bit or 64-bit.
#(Get-WmiObject Win32_OperatingSystem -computer $computer).OSArchitecture

#Step 4. To check machine name.
Get-WmiObject Win32_OperatingSystem -computer $computer | select name, OSArchitecture, CSName, OperatingSystemVersion

# (Get-WMIObject win32_operatingsystem -computer $computer) | select name, OSArchitecture, CSName | export-csv -append -path $FilePath

#Get-ADComputer -Filter * -Property * | Select-Object Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion