#Connects to your Office365 tenant
Connect-MsolService
# ============================================

# remove licences from deleted users
$delUsers = Get-MsolUser -ReturnDeletedUsers | Where-Object {$_.IsLicensed -eq $true}
$delUsers | foreach {
    $UPN = $_.UserPrincipalName
    Restore-MsolUser -UserPrincipalName $UPN
    (get-MsolUser -UserPrincipalName $UPN).licenses.AccountSkuId | foreach {
        $License = $_
        echo $UPN, "Removing direct license: $License"
        Set-MsolUserLicense -UserPrincipalName $UPN -RemoveLicenses $License -ErrorAction SilentlyContinue
    }
    Remove-MsolUser -UserPrincipalName $UPN -Force
}
# ==============================================
