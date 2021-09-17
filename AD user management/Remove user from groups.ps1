$Report = $User = $Username = $ADGroups = $null
#=========================================================================================================================
#Array
$Report = @()
 
#=========================================================================================================================
#User
Try{
    $User = Read-Host "Please provide username"
    $Username = (Get-ADUser -Identity $User.trim() -ErrorAction Stop)
}
Catch{
    $_.Exception.Message
    Read-Host "Press any key to exit..."
    Exit
}
 
#=========================================================================================================================
#Groups
$ADGroups  = Get-Content "C:\users\$env:username\desktop\groups.txt"
 
#=========================================================================================================================
#Checking user groups
Write-Host "User: $($Username.name)" -ForegroundColor Green
Foreach($Group in $ADGroups){
    $Group = $Group.Trim()
    $GroupDetails = $Status = $Removed = $Object = $null
    "Processing $Group"
    $GroupDetails = Get-ADGroup $Group -Properties members -ErrorAction SilentlyContinue | Where-Object {$_.members -eq $Username.DistinguishedName}
    If($GroupDetails){
        $Status = "True"
        Try{
            Remove-ADGroupMember -Identity $GroupDetails.DistinguishedName -Members $Username.DistinguishedName -Confirm:$true -ErrorAction Stop
            $Removed = "True"
        }
        Catch{
            $_.Exception.Message
            $Removed = "False"
        }
    }
    Else{
        $Status = "False"
        $Removed = " - "
    }
    $Object = New-Object PSObject -Property ([ordered]@{ 
 
        Username                = $Username.Name
        GroupName               = $Group
        Member                  = $Status
        Removed                 = $Removed
                 
    })
    $Report += $Object
}
If($Report){
    Return $Report | Out-GridView -Title "Resutls for $($Username.name)"
} 