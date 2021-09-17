#Чтобы получить список установленного ПО на удаленном компьютере (к примеру, с именем wks_name11), воспользуемся командлетом Invoke-command:
Invoke-command -computer ahoncharova {Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize }

#Invoke-command -computer ahoncharova {Get-ItemProperty HKLM:\Software\Wow64Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize }

$comp = "DPARKHOMENKO"

Invoke-command -computer $comp {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize }