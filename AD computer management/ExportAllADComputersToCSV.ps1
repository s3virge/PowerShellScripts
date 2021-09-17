# Write-Host "Script:" $PSCommandPath
Write-Host "Path:" $PSScriptRoot

$fileName = $PSScriptRoot + "\InteticsADCpmputersList.csv"

Get-ADComputer -Filter * -Properties * | select-object name, whenCreated, whenChanged, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $fileName

invoke-item $fileName
