#$FilePath = 'd:\DeviceDrivers.csv'
#Get-WmiObject Win32_PnPSignedDriver | select DeviceName, Manufacturer, DriverVersion | Export-Csv -Path $FilePath –notypeinformation


#$computers = Get-Content -Path d:\ALLCOMP.txt

#$comp = "yvdovitsa3"
#$comp = "reshetilo"
#$comp = "reshetilo2"
$comp = "kobzar"

$computers = @()

$computers += "kobzar"
$computers += "vnuchenko2"
$computers += "reshetilo2"

foreach ($computer in $computers)
{
    $FilePath = 'd:\' + $computer + '_DeviceDrivers.csv'
    Get-WMIObject Win32_PnPSignedDriver -computer $computer | select DeviceName, Manufacturer, DriverVersion | export-csv -path $FilePath –notypeinformation
}

pause