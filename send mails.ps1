$script = $PSScriptRoot + "\Here-temp-list-of-employee.csv" 

Import-Csv $script | ForEach-Object {
    if (($_.UserName -ne "") -or ($_.UserName -ne $null)) {
        $userName = $_.FirstName + " " + $_LastName
        $login = $_.Login
        # $eMail = $_.Email
        $eMail = 'dnl@intetics.com'
        $eMail = 'v.kobzar@intetics.com'
      
        Write-Host "Trying to send mail to $userName ($eMail)" -ForegroundColor Yellow

        ##############################################################################
        $MailBody = "Привет $userName. `n`n
        Для начала работы тебе необходимо выполнить вот эту инсрукцию.`n `
        https://intetics-my.sharepoint.com/:w:/p/dnl/EWtd_Y1JQoxKmkPqW9mJPN8BSHT_1WTs2UubG-9skyAuCg?e=L0JhMX `n`
        Твой логин: $login `n`
        пароль: "
        
        # Send-MailMessage -From 'intetics' -To $eMail -Subject 'Test message' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
        Send-MailMessage -From 'service-notifier@intetics.com' -To 'v.kobzar@intetics.com' -Subject 'Copy Backup completed' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
  }
}