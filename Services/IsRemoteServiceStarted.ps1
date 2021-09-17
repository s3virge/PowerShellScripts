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

Clear-Host

$computer = Read-Host "Please enter a computer name or IP"

#$computer = "KOVTONYUK2"
#$computer = "noleynik"
#$computer = "reshetilo2"
$computer = "VMOTINA"

Get-Service -ComputerName $computer -Name RemoteRegistry

#Write-Host 
#Write-host "Launch RemoteRegistry service"
Get-Service -ComputerName $computer -Name RemoteRegistry | Set-Service -StartupType Manual -PassThru | Start-Service

Get-Service -ComputerName $computer -Name RemoteRegistry

#Get-Service -ComputerName <Remote Computer> -Name RemoteRegistry | Set-Service -StartupType Disabled -PassThru| Stop-Service