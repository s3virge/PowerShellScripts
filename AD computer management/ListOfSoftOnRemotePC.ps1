$comp = "reshetilo2"
$comp = "ADUBROVSK"

Get-ADComputer -Filter {Name -like $comp}  -Properties * | select-object name, whenCreated, canonicalName, OperatingSystem, IPv4Address, enabled | Format-List

<# $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
        'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
 #>

write-host "------------------------------"
write-host "Installed soft on " $comp
write-host "------------------------------"

# Чтобы получить список установленного ПО на удаленном компьютере (к примеру, с именем wks_name11), воспользуемся командлетом Invoke-command:
# Invoke-command -computer $comp {Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize }

# write-host "$comp"
Invoke-command -computer $comp {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize }

Pause