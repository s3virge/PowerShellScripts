#$ComputerName = "AGANYSH"
#$ComputerName = "AHONCHAROVA"
$ComputerName = "AKHURDEI"

Write-Host $ComputerName
Invoke-Command -ComputerName $ComputerName -ScriptBlock { (New-Object -com "Microsoft.Update.AutoUpdate").Results.LastInstallationSuccessDate} -ErrorAction SilentlyContinue
pause

Invoke-Command -ComputerName $ComputerName -ScriptBlock { wmic qfe list } -ErrorAction SilentlyContinue
pause

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
Get-WmiObject -cl win32_reliabilityRecords -filter "sourcename = 'Microsoft-Windows-WindowsUpdateClient'" |
Select-Object @{LABEL = "date";EXPRESSION = {$_.ConvertToDateTime($_.timegenerated)}},user, productname
} -ErrorAction SilentlyContinue
pause

Write-Host "usoclient.exe ScanInstallWait"
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
usoclient.exe ScanInstallWait
} -ErrorAction SilentlyContinue
pause

Write-Host "usoclient.exe StartInstall"
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
usoclient.exe StartInstall
} -ErrorAction SilentlyContinue
pause

Invoke-Command -ComputerName $ComputerName -ScriptBlock { (New-Object -com "Microsoft.Update.AutoUpdate").Results.LastInstallationSuccessDate} -ErrorAction SilentlyContinue
Pause

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    Get-WmiObject -cl win32_reliabilityRecords -filter "sourcename = 'Microsoft-Windows-WindowsUpdateClient'" |
    Select-Object @{LABEL = "date";EXPRESSION = {$_.ConvertToDateTime($_.timegenerated)}},user, productname
    } -ErrorAction SilentlyContinue
