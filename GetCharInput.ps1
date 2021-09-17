##Formatting Variables
$fgc1 = 'cyan'
$fgc2 = 'white'
$indent = '  '

Function MainMenu {
    CLS
    Write-Host "###############"
    Write-Host "## Main Menu ##"
    Write-Host "###############"
    Write-Host -NoNewLine "$indent" "A " -ForegroundColor 'red'; Write-Host "== Options A" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "B " -ForegroundColor 'red'; Write-Host "== Options B" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "C " -ForegroundColor 'red'; Write-Host "== Options C" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "D " -ForegroundColor 'red'; Write-Host "== Options D" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "E " -ForegroundColor 'red'; Write-Host "== Options E" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "F " -ForegroundColor 'red'; Write-Host "== Options F" -ForegroundColor $fgc2
    Write-Host -NoNewLine "$indent" "G " -ForegroundColor 'red'; Write-Host "== Options G" -ForegroundColor $fgc2
    Write-Host ""

    #This gives you a way to set the current function as a variable.  The Script: is there because the variable has to
    #be available OUTSIDE the function.  This way you can make it back to the menu that you came from as long as all 
    #of your menus are in functions!
    $Script:SourceMenu = $MyInvocation.MyCommand.Name

    # Mode 1#
    #Use this for troubleshooting so that you can stay in ISE
    # Uncomment the 2 lines below to use Read-Host.  This will necessitate an ENTER Key. BUT, it WILL work in ISE
    #$K = Read-Host - "Which option?"
    #MenuActions

    # Mode 2#
    #Uncomment the line below to use ReadKey.  This will NOT necessitate an ENTER Key. BUT, it ## will NOT work ## in ISE
    ReadKey
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
        A {CLS;Write-Host "You Pressed A";Write-Host "Going to pause now... ";&pause}
        B {CLS;Write-Host "You pressed B";Write-Host "Going to pause now... ";&pause}
        C {CLS;Write-Host "You pressed C";Write-Host "Going to pause now... ";&pause}
        D {CLS;Write-Host "You pressed D";Write-Host "Going to pause now... ";&pause}
        E {CLS;Write-Host "You pressed E";Write-Host "Going to pause now... ";&pause}
        F {CLS;Write-Host "You pressed F";Write-Host "Going to pause now... ";&pause}
        G {CLS;Write-Host "You pressed G";Write-Host "Going to pause now... ";&pause}

        #This is a little strange of a process to exit out, but I like to use an existing mechanism to exit out
        #It sets the $SourceMenu to a process that will exit out.
        #I use this same process to jump to a different menu/sub-menu
        Q {$SourceMenu = "Exit-PSHostProcess";CLS;Write-Host "Exited Program"}
}
        #This next command will loop back to the menu you came from.  This, in essence, provides a validation that one of the 
        #"Switch ($X.key)" options were pressed.  This is also a good way to always find your way back to 
        #the menu you came from.  See "$Script:SourceMenu = $MyInvocation.MyCommand.Name" above.
        #
        #This is also the way that the Menu Item for Q exits out
    & $SourceMenu
}

# This runs the MainMenu function.  It has to be after all the functions so that they are defined before being called
MainMenu