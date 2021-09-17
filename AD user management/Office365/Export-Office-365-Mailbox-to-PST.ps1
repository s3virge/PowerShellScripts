# function Start-PSAdmin {
#     #Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
#     Start-Process PowerShell -Verb RunAs -ArgumentList ('-file "{0}"' -f $PSCommandPath)
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

# Install-Module -Name ExchangeOnlineManagement
# Import-Module ExchangeOnlineManagement 

$suspiciousEmail = Read-Host -Prompt "Enter suspicion e-mail" # suspicious - подозрительный
# Connect-IPPSSession This cmdlet is available only in the Exchange Online PowerShell V2 module
Connect-IPPSSession -UserPrincipalName vvk_adm@intetics.com #[-ConnectionUri <URL>] [-PSSessionOption $ProxyOptions]
# Connect-IPPSSession -UserPrincipalName vvk_adm@intetics.com -ConnectionUri https://ps.protection.outlook.com/powershell-liveid/ #[-PSSessionOption $ProxyOptions]
# Connect-IPPSSession -Credential (Get-Credential) -ConnectionUri https://ps.protection.outlook.com/powershell-liveid/


# if account is disbled this command will return - The location "asteganc@intetics.com" cannot
#be found.
# New-ComplianceSearch -name $suspiciousEmail -ExchangeLocation $suspiciousEmail

#If you want to search through inactive mailboxes, you need an additional
# attribute: -AllowNotFoundExchangeLocationsEnabled $true
New-ComplianceSearch -name $suspiciousEmail -ExchangeLocation $suspiciousEmail -AllowNotFoundExchangeLocationsEnabled $true
# New-ComplianceSearch -name $suspiciousEmail -ExchangeLocation all

Start-ComplianceSearch $suspiciousEmail

$status = Get-ComplianceSearch | Format-List name, items, size, jobprogress, status

if ($status.Count -gt 0){
    $status[0].Name 
}

# Get-PSSession | Format-Table -Property ComputerName, InstanceID
# Get-PSSession | Format-Table -Property id, Name

Disconnect-ExchangeOnline -Confirm:$false

#Start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" https://compliance.microsoft.com/contentsearchv2?viewid=search
Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://compliance.microsoft.com/contentsearchv2?viewid=search