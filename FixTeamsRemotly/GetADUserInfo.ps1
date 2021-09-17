
function GetUserInfo {
    $user = Read-Host "`nEnter user name "
    #$user = "reshet"
    $userName = "*" + $user + "*"

    $users = @()

    #$domain = "atwss.com"
    #$users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, whenChanged 

    $domain = "intetics.com.ua"
    $users += Get-ADUser -Server $domain -Filter { Name -like $userName } -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, mail, Department, enabled, canonicalName, LastLogonDate, whenChanged 
    # $users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object Surname 

    Write-Host "---------------------------------
    User info 
---------------------------------"
    $users | Format-List
 
    ############################################################################################
    $computers = @()
    $computerName = $userName
    $computers += Get-ADComputer -Filter { Name -like $computerName } -Properties * | select-object name, whenCreated, canonicalName, OperatingSystem, IPv4Address, enabled 

    Write-Host "---------------------------------
    Computer info 
---------------------------------"
    $computers | Format-List
}

function isQuit {
    Write-Host "----------------------------------------------"
    Write-Host "Press 'q' for quit or 'Enter' for continue: " -NoNewline
    # Write-Host "----------------------------------------------"
    $char = Read-Host

    if($char -eq 'q'){
        return $false    
    }    
    return $true;
}

# do{
    Clear-Host
    GetUserInfo
# }
# while (isQuit -eq $false)

#pause