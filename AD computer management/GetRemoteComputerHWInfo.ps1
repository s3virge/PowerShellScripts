
############################################################
# получить имя компа параметры которого будем узнавать
$remoteCompName = @()
# $remoteCompName = Read-Host "Enter computer name"

$remoteCompName = "kobzar"
$remoteCompName = "reshetilo2"

function GetInfo {
    $Info = Get-CimInstance -Class $Class -ComputerName $remoteCompNamee -Property *
    $Info | Select-Object -Property * | Out-String
    $Info
}

############################################################
# получить название установленной операционной системы
$os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $remoteCompName | Select-Object Caption

# получить название материнской платы
$mainBaord = Get-CimInstance -ClassName Win32_BaseBoard -ComputerName $remoteCompName | Select-Object Manufacturer, Product 

# получить название процессора
$processor = Get-CimInstance -ClassName Win32_Processor -ComputerName $remoteCompName | Select-Object Name, Caption

# получить объём озу
$memory = Get-CimInstance -ClassName Win32_PhysicalMemory -ComputerName $remoteCompName | Select-Object Capacity

# получить названия винчестеров
$drives = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $remoteCompName | Select-Object Caption 

# Получить назнавие видеокарты
$vga = Get-CimInstance -ClassName Win32_VideoController -ComputerName $remoteCompName | Select-Object Caption 

"OS - {0}" -f $os.Caption
"MainBoard - {0}, {1}" -f $mainBaord.Product, $mainBaord.Manufacturer
"CPU - {0}, {1}" -f $processor.Name, $processor.Caption
"Memory - {0}" -f $memory.Caption
"Drives - {0}" -f $drives.Caption
"Video - {0}" -f $vga.Caption