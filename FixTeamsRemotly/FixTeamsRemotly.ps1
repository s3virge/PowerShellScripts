
& "$PSScriptRoot\GetADUserInfo.ps1";

write-host "--------------------------------------"
$remotePCName = read-host "Enter computer name"

$cmdFileName = "FixTeams.cmd"
#$filePath = "\\$remotePCName\d$"
$filePath = "\\$remotePCName\С$"
$cmdFilePath = "$filePath\$cmdFileName"

function CreateCMDFile {
    
    $cmdFileContent = "@echo off

taskkill /f /im teams.exe
taskkill /f /im update.exe

set teams=""%APPDATA%\Microsoft\Teams""

del /s /q %teams%\desktop-config.json
del /s /q %teams%\settings.json
del /s /q %teams%\storage.json

start """" %LOCALAPPDATA%\Microsoft\Teams\Update.exe --processStart ""Teams.exe"" 

start /b """" cmd /c del ""%~f0""&exit /b
"

    #  $filePath = '\\{0}\d$\TeamsFix.cmd' -f $remotePCName
    $cmdFileContent | Out-File -FilePath $cmdFilePath -Force -Encoding "ASCII"
}

function SendMessage ($msg){
    Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $msg" -ComputerName $remotePCName
}

SendMessage "Временно можно запустить Teams онлайн на сайте portal.office.com."

CreateCMDFile
Invoke-Item $filePath

#SendMessage "На твоем диске D: находится файл FixTeams.cmd. Его необходимо запустить. Для этого выдели файл FixTeams мышкой и нажми на клавиатуре клавишу Enter или кликни два раза на нём левой кнопкой мыши. :-)"
SendMessage "На твоем диске C: находится файл FixTeams.cmd. Его необходимо запустить. Для этого выдели файл FixTeams мышкой и нажми на клавиатуре клавишу Enter или кликни два раза на нём левой кнопкой мыши. :-)"

#--------------------------------------------------------------------------------------------------------------------
# добавляет в ветку реестра на удалённом компе скрипт в автозагрузку
# reg add \\COMPUTER\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce /v script /t Reg_SZ /d "script.cmd"

# Enter-PSSession -ComputerName $remotePCName -Credential (Get-Credential)

# Invoke-Command -ComputerName $remotePCName -ScriptBlock {
#     get-childitem -path hkcu:\ -recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*ruonce*" }
# }

# Exit-PSSession

#--------------------------------------------------------------------------------------------------------------------
#проверить запустился ли на удалённой машине Teams
SendMessage "Когда Teams запуститься сообщи Виталию Кобзарю (Vitaliy Kobzar) о результатах."