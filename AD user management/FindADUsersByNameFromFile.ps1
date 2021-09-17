$FilePath = ".\ListOfFoundUsers.txt"
$listOfUsers = Get-Content -Path .\UsersList.txt
$users = @()

$domain = "atwss.com"

foreach ($user in $listOfUsers)
{
    $userName = "*" + $user + "*"
    $users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, whenChanged 
}

$domain = "intetics.com.ua"

foreach ($user in $listOfUsers)
{
    $userName = "*" + $user + "*"
    $users += Get-ADUser -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, whenChanged 
}

$users | ft 

#$users | Out-GridView  -Wait 
$answer = Read-Host "Pres 'E' to export result set to txt file or 'Enter' for continue"

if ($answer  -eq "E")
{
    #$users | export-csv -path $FilePath
    $users | ft -AutoSize | Out-File $FilePath
    Write-Host "Result set was exported to $FilePath" -ForegroundColor yellow
}

pause
#CMD /c PAUSE

Start-Process notepad++ $FilePath