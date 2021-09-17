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

<# 
Import-CSV $newpath | ForEach-Object {
    $samAccountName = $_."samAccountName"
    
    Get-AdPrincipalGroupMembership -Identity $Samaccountname | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $Samaccountname
} 
#>

# This command removes the users with SAM account name administrator and DavidChew from the group DocumentReaders.
# Remove-ADGroupMember -Identity "DocumentReaders" -Members administrator,DavidChew

<# $samAccountName = "v.kobzar"
$ADgroups = Get-ADPrincipalGroupMembership -Identity $samAccountName | Where-Object {$_.Name -ne "Domain Users"} | Format-Table -Property "name"
$ADgroups #>

<# 
#import the Active Directory module if not already up and loaded
$module = Get-Module | Where-Object {$_.Name -eq 'ActiveDirectory'}

if ($module -eq $null) {
		Write-Host "Loading Active Directory PowerShell Module"
		Import-Module ActiveDirectory -ErrorAction SilentlyContinue
	}
#>

$employeeSAM = Read-Host "Enter employee login/alias/SamAccountName: "
#$adServer = "adserver.yourcompany.com"

try {
	Get-ADUser -Identity $employeeSAM <# -Server  $adServer #>
	#if that doesn't throw you to the catch this person exists. So you can continue

    $ADgroups = Get-ADPrincipalGroupMembership -Identity $employeeSAM | Where-Object {$_.Name -ne "Domain Users"}
    
	if ($ADgroups -ne $null){
		Remove-ADPrincipalGroupMembership -Identity $employeeSAM -MemberOf $ADgroups <# -Server $adServer  -Confirm:$false #>
	}
}
catch {
	Write-Host "$employeeSAM is not in AD"
} 
#>