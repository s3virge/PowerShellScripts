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

# количество компов с Windows 7
write-host "------------------------------------------------"
Write-host "� AD ������� $compNumber ���������� � Windows 7"
write-host "------------------------------------------------"
$compNumber = (Get-ADComputer -Filter { enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' }).count 

# Get-ADComputer -Identity "kobzar" -Properties *
# Get-ADComputer -Filter * -Properties * | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $CSVFileName

# компы будут отсортированы по LastLogonDate
# Get-ADComputer -Filter * -Properties * | Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $CSVFileName

# выбрать компы из определённого юнита
# Get-ADComputer -SearchBase 'OU=Admins,OU=Workstations,DC=intetics,DC=com,DC=ua' -Filter * -Properties * | Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled <# | Export-Csv $CSVFileName #>

# сохранить в csv все компы в GIS
# Get-ADComputer -SearchBase 'OU=GIS, OU=Workstations, DC=intetics, DC=com, DC=ua' -Filter * -Properties * | Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $CSVFileName

# Get-ADComputer -SearchBase 'OU=GISDEV, OU=GIS, OU=Workstations, DC=intetics, DC=com, DC=ua' -Filter * -Properties * | Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $CSVFileName
# Get-ADComputer -SearchBase 'OU=GISDEV, OU=GIS, OU=Workstations, DC=intetics, DC=com, DC=ua' -Filter {enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' } -Properties * | Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $CSVFileName

# показать компы из Workstations-GIS-GISDEV не заблокированных и с Windows 7. Отсортировать их по LastLogonDate.
# Get-ADComputer -SearchBase 'OU=GISDEV, OU=GIS, OU=Workstations, DC=intetics, DC=com, DC=ua' -Filter {enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' } -Properties * | 
# Sort-Object LastLogonDate | 
# select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled |
# Format-Table -Wrap -AutoSize 

# выбрать все компы из Workstations-GIS-GISDEV не заблокированных и с Windows 7. Отсортировать их по LastLogonDate. Сохранить в txt файл
# Get-ADComputer -SearchBase 'OU=GISDEV, OU=GIS, OU=Workstations, DC=intetics, DC=com, DC=ua' -Filter {enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' } -Properties * | 
# Sort-Object LastLogonDate | 
# select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled |
# Format-Table -AutoSize | Out-File $TXTFileName

# $OU1 = "GISDEV"
# $OU2 = "GIS"

# $cmputers = Get-ADComputer -SearchBase "OU=$OU1, OU=$OU2, OU=Workstations, DC=intetics, DC=com, DC=ua" -Filter { enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' } -Properties * | 
#     Sort-Object LastLogonDate | 
#     select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled |
#     Format-Table -AutoSize | Out-File $TXTFileName

function GetOUWindows7Cpmputers ($OperationU1, $OperationU2) {    
    if ($OperationU2) {
        $searchBase = [string]::Format('OU={0}, OU={1}, OU=Workstations, DC=intetics, DC=com, DC=ua', $OperationU1, $OperationU2)
        $TXTFileName = $PSScriptRoot + "\Workstations-$OperationU1-$OperationU2"
    }
    else {
        $searchBase = [string]::Format('OU={0}, OU=Workstations, DC=intetics, DC=com, DC=ua', $OperationU1)
        # $TXTFileName = $PSScriptRoot + "\Workstations-$OperationU1.txt"
        $TXTFileName = $PSScriptRoot + "\Workstations-$OperationU1.csv"
    }

    #$ListOfComputers = Get-ADComputer -SearchBase $searchBase -Filter { enabled -eq "true" -and OperatingSystem -Like '*Windows 7*' } -Properties * | 
     #   Sort-Object LastLogonDate | select-object  name, whenCreated, whenChanged, LastLogonDate, canonicalName, OperatingSystem, IPv4Address, enabled;
		
		$ListOfComputers = Get-ADComputer -SearchBase $searchBase -Filter { enabled -eq "true" } -Properties * | 
        select-object  name, canonicalName;

    if ($ListOfComputers) {
        $fileExtention = ".txt"
        # $fileExtention = ".csv"

        $TXTFileName += $fileExtention
        $ListOfComputers | Format-Table -AutoSize | Out-String -Width 4096 | Out-File $TXTFileName
        # $ListOfComputers | Export-Csv $TXTFileName
    }
}

GetOUWindows7Cpmputers 'Accountants'
GetOUWindows7Cpmputers 'Admins'
GetOUWindows7Cpmputers 'Assistants'
GetOUWindows7Cpmputers 'Common'
GetOUWindows7Cpmputers 'PM' 'Developers' 
GetOUWindows7Cpmputers 'Directors'
GetOUWindows7Cpmputers 'GISDEV' 'GIS'
GetOUWindows7Cpmputers 'HERE_Temp' 'GIS'
GetOUWindows7Cpmputers 'ParkMe' 'GIS'
GetOUWindows7Cpmputers 'PL' 'GIS'
GetOUWindows7Cpmputers 'Students' 'GIS'
GetOUWindows7Cpmputers 'VM' 'GIS'
GetOUWindows7Cpmputers 'Win10x64' 'GIS'
GetOUWindows7Cpmputers 'Win7x64' 'GIS'
GetOUWindows7Cpmputers 'HR'
GetOUWindows7Cpmputers 'Laptops'
GetOUWindows7Cpmputers 'Lawyers'
GetOUWindows7Cpmputers 'Noname'
GetOUWindows7Cpmputers 'OfficeManagers'
GetOUWindows7Cpmputers 'Sales'
GetOUWindows7Cpmputers 'Virtual'
GetOUWindows7Cpmputers 'Developers'