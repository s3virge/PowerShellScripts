# $user = "v.kobzar"
# get-aduser $user -Properties title, department, manager



# Using regex (my go to method)
$listOfUsers = Get-ADUser  -filter * -Properties CN, Department, Manager |
    Select-Object CN, Department, @{Name = 'Manager'; Expression = {$_.Manager -replace 'CN=|,..=.+'}}

# Making a 2nd call to AD
# Get-ADUser $user -Properties CN, Department, Manager |
    # Select-Object CN, Department, @{Name = 'Manager'; Expression = {(Get-ADUser $_.Manager).Name}}
    
# Using .Split()
# Get-ADUser $user -Properties CN, Department, Manager |
    # Select-Object CN, Department, @{Name = 'Manager'; Expression = {$_.Manager.Split('=')[1].Split(',')[0]}}

    # foreach( $user in $listOfUsers){
    #     if ($user.Manager -eq "Aleksey Borodulin"){
    #         $user
    #     }
    # }

    $listOfUsers | Export-Csv "$PSScriptRoot\List Of Users with Manager.csv"
