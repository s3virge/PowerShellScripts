Get-Service -name "*acs*" | Where-Object {$_.Status -eq "Running"}
Get-Service -name "*acs*"

#Sort services by property value
Get-Service "s*" | Sort-Object status
pause