# Set-ExecutionPolicy bypass

$hostname = $Env:computername

$PSScriptRoot

ipconfig /all | Out-File "$PSScriptRoot\ipconfig_$hostname.txt"
# ipconfig /all | Out-File "e:\ipconfig_$hostname.txt"
