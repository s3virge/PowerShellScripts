$pcname = Read-Host "Enter computer name: "

$computerName = "*" + $pcname + "*"

Get-ADComputer -Filter {Name -like $computerName}  -Properties * | select-object name, whenCreated, canonicalName, OperatingSystem, IPv4Address, enabled | Format-List

pause