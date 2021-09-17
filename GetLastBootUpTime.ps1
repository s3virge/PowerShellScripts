Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime

Pause

Get-ADComputer -identity "reshetilo2" -Properties Name,OperatingSystem | Select-Object Name,OperatingSystem,
@{N='RAM (GB)';E={ (Get-WmiObject Win32_ComputerSystem -ComputerName $_.Name).TotalPhysicalMemory / 1GB -as [int]}},
@{N='Used RAM slot';E={ (Get-WmiObject Win32_physicalmemory -ComputerName $_.Name).count}},
# @{N='LastBootUpTime';E={ (Get-WmiObject Win32_OperatingSystem -ComputerName $_.Name).lastbootuptime($_.ConvertToDateTime)}}
@{N='LastBootUpTime';E={ Get-CimInstance -ClassName win32_operatingsystem -ComputerName $_.Name <# | Select-Object lastbootuptime #>}}

$x,$y = Get-CimInstance -ClassName Win32_Process
$x | Format-Table -Property Name,KernelModeTime -AutoSize
$y | Get-CimInstance | Format-Table -Property Name,KernelModeTime -AutoSize


Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName reshetilo2 | Format-List