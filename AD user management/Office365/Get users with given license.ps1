function ConnectToMSO {
    #$username = ""
    #$password = ConvertTo-SecureString "" -AsPlainText -Force
    #$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

    try {
	    #Connect-MsolService -Credential $psCred -ErrorAction Stop
        #$credential = Get-Credential "AdminOfficeAccount"
        #Connect-MsolService -Credential $credential -ErrorAction Stop
        Connect-MsolService -ErrorAction Stop
    }
    catch {
        $text = "Something went wrong!"
        ShowMessageBox -text $text
        exit
    }
}

ConnectToMSO

$BusinesBasic = "O365_BUSINESS_ESSENTIALS"
$BusinesStandart = "O365_BUSINESS_PREMIUM"
$Office365E1 = "STANDARDPACK"
#$Office365E3  = "ENTERPRISEPACK"
$Microsoft365E3  = "SPE_E3"
$Office365F3 = "DESKLESSPACK"
$Intune = "INTUNE_A"

$OfficeLicense = $Microsoft365E3
$outputFile = "d:\Users_with_office_$OfficeLicense.csv"

Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match $OfficeLicense} | Out-GridView
#Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match $OfficeLicense} | Export-Csv $outputFile

$OfficeLicense = $Intune
Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match $OfficeLicense} | Export-Csv $outputFile

Start-Process notepad $outputFile

#get-aduser $user -Properties title, department, manager | Select-Object title,department,@{name='ManagerName';expression={(Get-ADUser -Identity $_.manager | Select-Object -ExpandProperty name)}},@{name='ManagerEmailAddress';expression={(Get-ADUser -Identity $_.manager -Properties emailaddress | Select-Object -ExpandProperty emailaddress)}} | Format-list