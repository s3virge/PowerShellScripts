$user = Read-Host "Enter user name: "
$userName = "*" + $user + "*"

$users = @()

#$domain = "atwss.com"

#$users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, whenChanged 

$domain = "intetics.com.ua"

$users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, mail, Department, enabled, canonicalName, whenChanged 
# $users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * 

# $users | Format-Table
$users | Format-List

pause