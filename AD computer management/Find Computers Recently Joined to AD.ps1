#$output = Read-Host "Press 'Y' for output to file or 'Enter' to continue"

$recently = [DateTime]::Today.AddDays(-10)

write-host $recently

#### shows all avalable properties
#Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties * # | select-object name, whenCreated, canonicalName

#Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated | select-object name, whenCreated, distinguishedName

Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties * | select-object name, whenCreated, WhenChanged, canonicalName, OperatingSystem, IPv4Address, enabled | ft | Out-String -Width 4096