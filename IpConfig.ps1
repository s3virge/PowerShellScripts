
# $computerName = read-host "Enter computer name"
# $computerName = "reshetilo2"
$computers = "MR-GIS-POLAND", "MR-GIS-VENEZUEL", "MR-GIS-ITALY", "HP P2055dn Europe (ParkMe)"

foreach($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock { 
        #    $output = ipconfig /all
        #    $output | Select-String "Default Gateway" 
        
           $output = ipconfig /all 
           #$output | Select-String "Physical Address"
        }
}
 <#  -credential v.kobzar #>

 pause