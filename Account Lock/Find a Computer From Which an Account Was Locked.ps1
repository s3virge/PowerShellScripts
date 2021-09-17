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

$Usr = Read-Host "Please enter a user name" 
#$Usr = "kobzar"

$Pdc = (Get-AdDomain).PDCEmulator

$ParamsEvn = @{
'Computername' = $Pdc
'LogName' = 'Security'
'FilterXPath' = "*[System[EventID=4740] and EventData[Data[@Name='TargetUserName']='$Usr']]"
}

Clear-Host
write-host "$Usr was locked on workstation"

$Evnts = Get-WinEvent @ParamsEvn
$Evnts | foreach {$_.Properties[1].value + ' ' + $_.TimeCreated}