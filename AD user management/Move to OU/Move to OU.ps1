# $FilePath = "$PSScriptRoot\RemoteDevelopers.txt"
# $toOrganisationUnit = "OU=Developers,OU=Remote,OU=Personnel,DC=intetics,DC=com,DC=ua"

# $FilePath = "$PSScriptRoot\RemoteParkMe.txt"
# $toOrganisationUnit = "OU=ParkMe,OU=GIS,OU=Remote,OU=Personnel,DC=intetics,DC=com,DC=ua"

# $FilePath = "$PSScriptRoot\RemoteSales.txt"
# $toOrganisationUnit = "OU=Sales,OU=Remote,OU=Personnel,DC=intetics,DC=com,DC=ua"

$FilePath = "$PSScriptRoot\RemoteGisDev.txt"
$toOrganisationUnit = "OU=GISDev,OU=GIS,OU=Remote,OU=Personnel,DC=intetics,DC=com,DC=ua"

$listOfUsers = Get-Content -Path $FilePath

foreach ($user in $listOfUsers)
{
    # Get-ADUser $user | Move-ADObject -TargetPath 'OU=Developers,OU=Remote,OU=Personnel,DC=intetics,DC=com,DC=ua'
    Get-ADUser $user | Move-ADObject -TargetPath $toOrganisationUnit
}
