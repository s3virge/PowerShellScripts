$computerName = Read-Host "Enter computer name"
$computerName = "reshetilo2"
$computers = "MR-GIS-POLAND", "MR-GIS-VENEZUEL", "MR-GIS-ITALY"

# foreach($computer in $computers) {
# 	write-host "`n $computer"
# 	# Solution 1
# 	Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $computer | 
# 	Select-Object -Property MACAddress, 
	 
# 	# Solution 2
# 	Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $computer | 
# 	Select-Object -Property MACAddress
	 
# 	# Solution 3
# 	getmac.exe /s $computer
# 	write-host "`n"
# }

Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $computerName <# | 
	Select-Object -Property MACAddress,  #>