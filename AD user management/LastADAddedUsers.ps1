$lastday = ((Get-Date).AddDays(-10))
$filename = Get-Date -Format yyyy.MM.dd
$exportcsv="D:\OneDrive - Intetics Inc\PowerShell\last_added_users_" + $filename + ".csv"
Get-ADUser -filter {(whencreated -ge $lastday)} #| Export-csv -path $exportcsv