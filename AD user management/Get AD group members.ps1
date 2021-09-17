<#
    http://winitpro.ru/index.php/2018/02/20/upravlenie-gruppami-ad-s-pomoshhyu-powershell/

    The $ErrorActionPreference variable specifies the action to take in response to an error occurring. The following values are supported:
    SilentlyContinue — Don't display an error message continue to execute subsequent commands.
    Continue — Display any error message and attempt to continue execution of subsequence commands.
    Inquire — Prompts the user whether to continue or terminate the action
    Stop — Terminate the action with error.
#>

function getAdGroups {
    write-host "
    ------------------------------------
        Will be select AD groups.
    ------------------------------------" -ForegroundColor Yellow

    $groupName = Read-Host "Enter the name of the group: "
    
    Get-ADGroup -LDAPFilter “(name=*$groupName*)” | Select-Object name | Format-Table
} 

function getAdGroupMembers {
    write-host "
    ------------------------------------
        Will be shown group members.
    ------------------------------------" -ForegroundColor Yellow

    $group = Read-Host "Enter group name: "
     Get-ADGroupMember $group | Format-Table name
}

getAdGroups
getAdGroupMembers

pause
