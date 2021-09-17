# function Start-PSAdmin {
# 	Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
# }

# function IsUserAdmin {
#   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#   $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#   return $boolResult
# }

# #если юзер не админ, то запускаемся с повышенными привелегиями
# if ((IsUserAdmin) -eq $false) {
# 	Start-PSAdmin
# 	exit
# }

# Clear-Host
#########################################################################################################################

# $username = Read-Host -Prompt "Input full user name (belindan@litwareinc.com)"
# $password = ConvertTo-SecureString (Read-Host -Prompt "Input password" -AsSecureString) -AsPlainText -Force
# $psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

#$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ("", "")

# Install-Module MSOnline

#Connect-MsolService -Credential $psCred
Connect-MsolService

$userFullName = Read-Host -Prompt "Input user login with domain name (belindan@litwareinc.com)"
$userAccount = Get-MsolUser -UserPrincipalName $userFullName

#$userAccount
#$userAccount.licenses.accountskuid

Set-MsolUserLicense -UserPrincipalName $userFullName -RemoveLicenses $userAccount.licenses.accountskuid

Write-Output -InputObject 'This script will self-exit in 5 seconds.'
5..1 | ForEach-Object {
                If($_ -gt 1) {
                    "	_ seconds"
                }
                Else {
                    "	$_ second"
              } # End If.
    Start-Sleep -Seconds 1
  } # End ForEach-Object.
 
#Write-Output -InputObject 'Self destruction.'