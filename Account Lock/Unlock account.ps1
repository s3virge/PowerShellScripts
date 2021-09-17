# function Start-PSAdmin {
# 	Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
# }

# function IsUserAdmin {
#   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#   $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#   return $boolResult
# }

#если юзер не админ, то запускаемся с повышенными привелегиями
# if ((IsUserAdmin) -eq $false) {
# 	Start-PSAdmin
# 	exit
# }

Clear-Host

$usr = Read-Host "Please enter a user name" 

if ([string]::IsNullOrEmpty($usr)) {
  $usr = "v.motina"  
}

Get-ADUser -Identity $usr | Unlock-ADAccount

Clear-Host
Write-host "The user $usr was unlocked"