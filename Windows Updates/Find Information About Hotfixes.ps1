Get-WmiObject -cl win32_reliabilityRecords -filter "sourcename = 'Microsoft-Windows-WindowsUpdateClient'" |
Select-Object @{LABEL = "date";EXPRESSION = {$_.ConvertToDateTime($_.timegenerated)}},user, productname
pause