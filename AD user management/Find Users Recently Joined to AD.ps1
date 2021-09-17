$lastday = ((Get-Date).AddDays(-10))
$filename = Get-Date -Format yyyy.MM.dd
$exportcsv=".\last_added_users_" + $filename + ".csv"
Get-ADUser -filter {(whencreated -ge $lastday)} -Properties * | select-object Name, Title, SamAccountName, Enabled, Description, Department, CanonicalName, whenChanged  #| Export-csv -path $exportcsv

pause