
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

# Write-Host "Script:" $PSCommandPath
Write-Host "Path:" $PSScriptRoot

$TXTFileName = $PSScriptRoot + "\InteticsADComputersList.txt"
$csvFileName = $PSScriptRoot + "\Computers_HWInfo.csv"

# Get-ADComputer -Filter * -Properties * | select-object name, whenCreated, whenChanged, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $fileName

#Get-ADComputer -Filter {(Enabled -eq $True)} -Properties * | Select-Object Name | Format-Table -AutoSize | Out-String -Width 4096 | Out-File $TXTFileName

Get-ADComputer -Filter {(Enabled -eq $True)} -Properties * | Select-Object Name | Format-Table -AutoSize | Out-File $TXTFileName
$computers = Get-Content -Path $TXTFileName
$message = ""
$message | Out-File $csvFileName -Encoding UTF8

foreach( $comp in $computers){
    $comp = $comp.Trim();

    if ($comp -eq "" -or $comp -eq "Name" -or $comp -eq "----") {
        continue
    }
    
    #проверить доступность компа    
    if ((Test-Connection -computer $comp -quiet) -eq $True)
    {
        ###########################################################
		# получить название установленной операционной системы
		$os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $comp | Select-Object Caption

		# получить название материнской платы
		$mainBaord = Get-CimInstance -ClassName Win32_BaseBoard -ComputerName $comp | Select-Object Manufacturer, Product 

		# получить название процессора
		$processor = Get-CimInstance -ClassName Win32_Processor -ComputerName $comp | Select-Object Name, Caption

		# получить объём озу
		$memory = Get-CimInstance -ClassName Win32_PhysicalMemory -ComputerName $comp | Select-Object Capacity

		# получить названия винчестеров
		$drives = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $comp | Select-Object Caption 

		# Получить назнавие видеокарты
		$vga = Get-CimInstance -ClassName Win32_VideoController -ComputerName $comp | Select-Object Caption 

		Write-Host "--- HostName $comp ---" -ForegroundColor Green
		"OS 		- {0}" -f $os.Caption
		"MainBoard 	- {0}, {1}" -f $mainBaord.Product, $mainBaord.Manufacturer
		"CPU 		- {0}, {1}" -f $processor.Name, $processor.Caption
		"Memory		- {0}" -f $memory.Caption
		"Drives		- {0}" -f $drives.Caption
		"Video 		- {0}" -f $vga.Caption

		$message = "$comp"
		$message += "OS	- {0}," -f $os.Caption
		$message += "MainBoard - {0} {1}," -f $mainBaord.Product, $mainBaord.Manufacturer
		$message += "CPU - {0} {1}," -f $processor.Name, $processor.Caption
		$message += "Memory - {0}," -f $memory.Caption
		$message += "Drives - {0}," -f $drives.Caption
		$message += "Video - {0}" -f $vga.Caption
    }
    else {
        Write-Host ":( $comp is unreachable" -ForegroundColor Red
    }

    $message | Out-File $csvFileName -Append -Encoding UTF8
}
 
pause