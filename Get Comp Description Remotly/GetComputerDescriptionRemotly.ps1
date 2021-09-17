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

$computer = Read-Host "Please enter a computer name or IP" 
#$computer = "NOLEYNIK"
#$computer = "kobzar"

Get-Service -ComputerName $computer -Name RemoteRegistry
Get-Service -ComputerName $computer -Name RemoteRegistry | Set-Service -StartupType Manual -PassThru | Start-Service
Get-Service -ComputerName $computer -Name RemoteRegistry

$description

$keytype = [Microsoft.Win32.RegistryHive]::LocalMachine 
if($reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype, $computer)) {
  $regKey= $reg.OpenSubKey("SYSTEM\\CurrentControlSet\\Services\\LanmanServer\\Parameters")
  $description = $regKey.GetValue("srvcomment")
}
else {
  Write-Host "Something went wrong";
}

write-host "$computer - $description" -NoNewline 