
<#function Start-PSAdmin {
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

Install-Module MSOnline

#>
#########################################################################

# $username = Read-Host -Prompt "Input full user name (belindan@litwareinc.com)"
# $password = ConvertTo-SecureString (Read-Host -Prompt "Input password" -AsSecureString) -AsPlainText -Force
# $psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$username = "vvk_adm@intetics.com"
$password = ConvertTo-SecureString "p@$$W0rd" -AsPlainText -Force
#$password = ConvertTo-SecureString (Read-Host -Prompt "Input password" -AsSecureString) -AsPlainText -Force
$password = Read-Host -Prompt "Input password" 
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

#########################################################################
try {
  Connect-MsolService -Credential $psCred -ErrorAction Stop
	# Connect-MsolService -ErrorAction Stop
}
catch {
  Write-Host "SomeThing Does not work! Exit" -BackgroundColor Red
    exit
}

# $userFullName = Read-Host -Prompt "Input full user name (belindan@litwareinc.com)"
$userFullName = "v.kobzar@intetics.com"

# Get-MsolUser -UserPrincipalName $userFullName | Format-List DisplayName,Licenses

$license = (Get-MsolUser -UserPrincipalName $userFullName).Licenses.AccountSku.SkuPartNumber

if ($license -eq "ENTERPRISEPACK"){
  Write-host "ENTERPRISEPACK is it"
}

#shows available licences
$accountSku = Get-MsolAccountSku
foreach ($element in $accountSku) {
  switch ($element.SkuPartNumber){
    "ENTERPRISEPACK" {
      write-host $element.SkuPartNumber "licenses left - " ($element.ActiveUnits - $element.ConsumedUnits)
    }
    "O365_BUSINESS_PREMIUM" {
      write-host $element.SkuPartNumber "licenses left - " ($element.ActiveUnits - $element.ConsumedUnits)
    }
    "O365_BUSINESS_ESSENTIALS" {
      write-host $element.SkuPartNumber "licenses left - " ($element.ActiveUnits - $element.ConsumedUnits)
    }
    "DESKLESSPACK" {
      write-host $element.SkuPartNumber "licenses left - " ($element.ActiveUnits - $element.ConsumedUnits)
    }
  }

  # показать все доступные лицензии
  Write-Output ($element.SkuPartNumber + " licenses left - " + ($element.ActiveUnits - $element.ConsumedUnits))
}

# (Get-MsolUser -UserPrincipalName $userFullName).Licenses.ServiceStatus
pause