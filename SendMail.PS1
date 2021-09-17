
$CopyingStarted = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

$CopyingFinished = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

$TimeSpan = NEW-TIMESPAN -Start $CopyingStarted -End $CopyingFinished

$hours = $TimeSpan.Hours
$minutes = $TimeSpan.Minutes
$seconds = $TimeSpan.Seconds

$MailBody = "Copying the backups to an external drive has completed.`
`n`nCopying was started $CopyingStarted. `
Copying was finished $CopyingFinished. `
Copying was complite in $hours hours, $minutes minutes, $seconds seconds"

Send-MailMessage -From 'v.kobzar@intetics.com' -To 'v.kobzar@intetics.com' -Subject 'Copy Backup completed' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
pause