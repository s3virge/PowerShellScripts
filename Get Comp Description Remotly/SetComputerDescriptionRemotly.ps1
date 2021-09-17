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
#$computer = "kobzar"
#$computer = "NOLEYNIK"
#$computer = "VMOTINA"
#$computer = "OVOINOVA"

$newValueData = Read-Host "Please enter a computer description" 
#$newValueData = "3260-OC"

$newValuePath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$newValueName = "srvcomment"

Get-Service -ComputerName $computer -Name RemoteRegistry
Get-Service -ComputerName $computer -Name RemoteRegistry | Set-Service -StartupType Manual -PassThru | Start-Service
Get-Service -ComputerName $computer -Name RemoteRegistry

#edit existing value
#Invoke-Command -ComputerName $computer {Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name $newValueName -Value $newValue}

# что-то win-rm не работает.
#Invoke-Command -ComputerName $computer {New-ItemProperty -Path $newValuePath -PropertyType String -Name $newValueName -Value $newValueData}

REG ADD \\$computer\HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters /v $newValueName /t REG_SZ /d $newValueData