# $remotePCName = read-Host "Enter computer name"
$remotePCName = "KHARCHEVNIKOVA"

$regKey = "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$regKeyName = "IgnoreRemoteKeyboardLayout"
$regKeyType = "REG_DWORD"
$regKeyValue = "1"

# добавляет в ветку реестра на удалённом компе скрипт в автозагрузку
# reg add "\\$remotePCName\$regKey" /v $regKeyName /t $regKeyType /d $regKeyValue
# Invoke-Command –ComputerName $remotePCName –ScriptBlock { Get-Item -Path $regKey }

# Invoke-Command –ComputerName $remotePCName –ScriptBlock { Get-WinUserLanguageList }

# Get-PSSession -ComputerName $remotePCName -Credential "v.kobzar" 

$session = New-PSSession -ComputerName $remotePCName
 Enter-PSSession -Session $session

#  Exit-PSSession