$groupName = Read-Host "Enter group name: "

Get-ADGroup -LDAPFilter “(name=*$groupName*)” | Format-Table
