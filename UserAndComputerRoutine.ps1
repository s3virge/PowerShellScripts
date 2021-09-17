# Write-Host "Script:" $PSCommandPath
# Write-Host "Path:" $PSScriptRoot

##Formatting Variables
$fgc1 = 'cyan'
$fgc2 = 'white'
$indent = '  '
$pingCount = 20

Function MainMenu {
    Clear-Host;   
    # Write-Host "-=============-"   
    # Write-Host "-= Main Menu =-"   
    # Write-Host "-=============-"   
    Write-Host -NoNewLine "$indent" "P " -ForegroundColor 'red'; Write-Host "Print Computers Recently Joined to AD" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "U " -ForegroundColor 'red'; Write-Host "User Info" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "R " -ForegroundColor 'red'; Write-Host "Reboot remote computer" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "S " -ForegroundColor 'red'; Write-Host "Shutdown remote computer" -ForegroundColor $fgc2
    Write-Host ""
    Write-Host -NoNewLine "$indent" "Q " -ForegroundColor 'red'; Write-Host "For Quit" -ForegroundColor $fgc2
    Write-Host ""

    #This gives you a way to set the current function as a variable.  The Script: is there because the variable has to
    #be available OUTSIDE the function.  This way you can make it back to the menu that you came from as long as all 
    #of your menus are in functions!
    $Script:SourceMenu = $MyInvocation.MyCommand.Name

    # Mode 1#
    #Use this for troubleshooting so that you can stay in ISE
    # Uncomment the 2 lines below to use Read-Host.  This will necessitate an ENTER Key. BUT, it WILL work in ISE
    $K = Read-Host - "Which option?"
    MenuActions

    # Mode 2#
    #Uncomment the line below to use ReadKey.  This will NOT necessitate an ENTER Key. BUT, it ## will NOT work ## in ISE
    # ReadKey
}

Function ReadKey {
    Write-Host "Please make your choice..."
    Write-Host ""
    Write-Host "Press Q to quit"
    $KeyPress = [System.Console]::ReadKey()

    #This gets the keypress to a common variable so that both modes work (Read-Host and KeyPress)
    $K = $KeyPress.Key

    #Jumps you down to the MenuActions function to take the keypress and "Switch" to it
    MenuActions
}

Function MenuActions {
    Switch ($K) {
        P {
            PrintRecentlyJoinedComputers;
        }
        
        U {
            UserInfo;
        }

        R {
            RemoteReboot;
        }

        S { 
            RemoteShutdown;
        }
        
        #This is a little strange of a process to exit out, but I like to use an existing mechanism to exit out
        #It sets the $SourceMenu to a process that will exit out.
        #I use this same process to jump to a different menu/sub-menu
        Q { 
            $SourceMenu = "Exit-PSHostProcess"; Clear-Host; ; Write-Host "Exited Program" 
        }
    }
    #This next command will loop back to the menu you came from.  This, in essence, provides a validation that one of the 
    #"Switch ($X.key)" options were pressed.  This is also a good way to always find your way back to 
    #the menu you came from.  See "$Script:SourceMenu = $MyInvocation.MyCommand.Name" above.
    #
    #This is also the way that the Menu Item for Q exits out
    & $SourceMenu
}

function RemoteReboot {
    Clear-Host;
    $compName = @()
    $compName = read-host "Enter computer name that will be rebooted"
    Restart-Computer -ComputerName $compName -Force
    ping $compName -n $pingCount
}

function RemoteShutdown {
    Clear-Host;
    $compName = @()
    $compName = read-host "Enter computer name that will be shutdown"
    Stop-Computer -ComputerName $compName -Force
    ping $compName -n $pingCount
}

function PrintRecentlyJoinedComputers {
    Clear-Host;
    # & "$PSScriptRoot\Find Computers Recently Joined to AD.ps1";
    #$output = Read-Host "Press 'Y' for output to file or 'Enter' to continue"

    $recently = [DateTime]::Today.AddDays(-10)

    #Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties * # | select-object name, whenCreated, canonicalName
    #Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated | select-object name, whenCreated, distinguishedName
    Get-ADComputer -Filter 'WhenCreated -ge $recently' -Properties whenCreated, canonicalName, IPv4Address, OperatingSystem, enabled | select-object name, whenCreated, canonicalName, OperatingSystem, IPv4Address, enabled | format-table

    pause
}

function UserInfo {
    Clear-Host;
    # & "$PSScriptRoot\GetADUserInfo.ps1";
    $user = Read-Host "Enter user name "
    #$user = "reshet"
    $userName = "*" + $user + "*"

    $users = @()

    #$domain = "atwss.com"
    #$users += Get-ADUser -Server $domain -Filter {Name -like $userName} -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, whenChanged 

    $domain = "intetics.com.ua"
    $users += Get-ADUser -Server $domain -Filter { Name -like $userName } -Properties * | Select-Object SamAccountName, name, title, office, mobilePhone, Department, enabled, canonicalName, LastLogonDate, whenChanged 
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
    
    pause
}

# This runs the MainMenu function.  It has to be after all the functions so that they are defined before being called
MainMenu

# работает. Windows 10 перезагрузил с выводом сообщения
#shutdown /r /m /f \\WIN-B60G6K46URS /t 120 /c “ВАШ КОМПЬЮТЕР БУДЕТ ПЕРЕЗАГРУЖЕН ЧЕРЕЗ 120 СЕКУНД! ПРОСИМ ЗАКРЫТЬ ВСЕ ПРОГРАММЫ С СОХРАНИЕМ ИЗМЕНЕНИЙ.”