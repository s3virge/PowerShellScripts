# function Start-PSAdmin {
# 	Start-Process PowerShell -Verb RunAs -ArgumentList ('-file "{0}"' -f $PSCommandPath)
# }

# function IsUserAdmin {
#   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#   $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#   return $boolResult
# }

# #если юзер не админ, то запускаемся с повышенными привелегиями
# if ((IsUserAdmin) -eq $false) {
# 	Start-PSAdmin
# 	exit
# }

Clear-Host
########################################################################################################################
# Hide PowerShell Console
# Add-Type -Name Window -Namespace Console -MemberDefinition '
# [DllImport("Kernel32.dll")]
# public static extern IntPtr GetConsoleWindow();
# [DllImport("user32.dll")]
# public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
# '
# $consolePtr = [Console.Window]::GetConsoleWindow()
# [Console.Window]::ShowWindow($consolePtr, 0)

############################################################################
$script = $PSScriptRoot + "\Subcontractors GDE 02.08.2021.csv" 
# $script = "D:\OneDrive - Intetics Inc\HERE_new_users.csv" 

$OfficeLicense = "intetics:DESKLESSPACK" # office 365 F3 for subcontractors

Connect-MsolService -ErrorAction Stop

Import-Csv $script | ForEach-Object {
  try {
    if ($_.SamAccountName -ne "") {
      $ulogin = $_.SamAccountName
      $upn = $_.SamAccountName + "@intetics.com"
      $uname = $_.FirstName + " " + $_.LastName
      $password = $_.Password.trim()
      $eMail = $_.Email
      $PM = $_.PM
  
      Write-Host "`nCurrent user $uname ($upn)" -ForegroundColor Yellow
        
      # New-ADUser -Name $uname `
      # -GivenName $_.FirstName `
      # -Surname $_.LastName `
      # -UserPrincipalName $upn `
      # -SamAccountName $_.samAccountName `
      # -Path $_.OU `
      # -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) `
      # -Enabled $true
      
      # Write-Host "  Employee $uname ($upn) was created" -ForegroundColor Green

      # Chenge user password
      Set-ADAccountPassword -Identity $ulogin -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
      
      Write-Host "  Password was chenged" -ForegroundColor Green
      
      $ulogin | Set-ADUser -ChangePasswordAtLogon $true
      
      Write-Host "  Change Password At Logon was set" -ForegroundColor Green

      $ulogin | Set-ADUser -Manager $PM
      
      Write-Host "  Manager was set" -ForegroundColor Green

      # Add-AdGroupMember -Identity "APP_Java_v8.0.172" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "g_gis" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "gis.all" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "Ukraine All Announcements" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "Kharkiv BPO All" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "Kharkiv GIS HERE ISA Newcomers" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "ACL_RAS_SSTP_BPO_HERE" -Members $_.samAccountName
      # Add-AdGroupMember -Identity "ACL_RAS_L2TP_BPO_HERE" -Members $_.samAccountName

      Add-AdGroupMember -Identity "SSO-Enabled External Users UA" -Members $_.samAccountName      
      
      Write-Host "  To AD groups was added" -ForegroundColor Green
      
      ## Remove user from group
      # Remove-ADGroupMember -Identity "ACL_RAS_L2TP_Kharkiv" -Members $_.samAccountName -Confirm:$false
      # Remove-ADGroupMember -Identity "Kharkiv GIS Here engineers" -Members $_.samAccountName -Confirm:$false
              
      # Set-ADUser -Identity $_.samAccountName -PasswordNeverExpires $true
      # Write-Host "  Password Never Expires $uname ($upn) was set" -ForegroundColor Green

      # ASsign o365 lisence
      Set-MsolUser -UserPrincipalName $upn -UsageLocation UA
      Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $OfficeLicense     
      
      Write-Host "  Lisence was assigned" -ForegroundColor Green

      # # get user licenses
      # $license = (Get-MsolUser -UserPrincipalName $upn).Licenses.AccountSku.SkuPartNumber
      # write-host "$upn hes lisens ussigned  $license"

      # turnon MFA
      $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
      $st.RelyingParty = "*"
      $st.State = "Enabled"
      $sta = @($st)
      Set-MsolUser -UserPrincipalName $upn -StrongAuthenticationRequirements $sta
      
      Write-Host "  MFA was turned On" -ForegroundColor Green

      #############################################################################
      # Write-Host "Send mail to $uname ($eMail)" -ForegroundColor Yellow
     
      # $MailBody = "Hi, $uname. `
      # `
      # To begin with, your need to do this instruction `
      # https://intetics-my.sharepoint.com/:w:/p/dnl/EWtd_Y1JQoxKmkPqW9mJPN8BSHT_1WTs2UubG-9skyAuCg?e=L0JhMX `
      # `
      # Your login: $upn `
      # Your password: $password `
      # `
      # For any questions join telegram: https://t.me/joinchat/WDmrMkAFQKQxZmEy `
      # `
      # Best regards `
      # Team administrators"

      # Send-MailMessage -From 'service-notifier@intetics.com' -To $eMail -Subject 'intetics credentials' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
      #Send-MailMessage -From 'service-notifier@intetics.com' -To 'v.sakhno@intetics.com' -Subject 'intetics credentials' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
    }
  }
  catch {
    Write-Host "$uname ($upn) $_" -ForegroundColor Red
  } 
}