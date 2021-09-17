$pcName = read-host "Enter computer name "
# $pcName = "BUROVSKAYA"

$msg = read-host "Enter your message "

# $msg = "Привет. Временно можно запустить Тимс онлайн на сайте portal.office.com"
Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $msg" -ComputerName $pcName