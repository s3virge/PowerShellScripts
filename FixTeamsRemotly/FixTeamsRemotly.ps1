
& "$PSScriptRoot\GetADUserInfo.ps1";

write-host "--------------------------------------"
$remotePCName = read-host "Enter computer name"

$cmdFileName = "FixTeams.cmd"
#$filePath = "\\$remotePCName\d$"
$filePath = "\\$remotePCName\�$"
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

SendMessage "�������� ����� ��������� Teams ������ �� ����� portal.office.com."

CreateCMDFile
Invoke-Item $filePath

#SendMessage "�� ����� ����� D: ��������� ���� FixTeams.cmd. ��� ���������� ���������. ��� ����� ������ ���� FixTeams ������ � ����� �� ���������� ������� Enter ��� ������ ��� ���� �� �� ����� ������� ����. :-)"
SendMessage "�� ����� ����� C: ��������� ���� FixTeams.cmd. ��� ���������� ���������. ��� ����� ������ ���� FixTeams ������ � ����� �� ���������� ������� Enter ��� ������ ��� ���� �� �� ����� ������� ����. :-)"

#--------------------------------------------------------------------------------------------------------------------
# ��������� � ����� ������� �� �������� ����� ������ � ������������
# reg add \\COMPUTER\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce /v script /t Reg_SZ /d "script.cmd"

# Enter-PSSession -ComputerName $remotePCName -Credential (Get-Credential)

# Invoke-Command -ComputerName $remotePCName -ScriptBlock {
#     get-childitem -path hkcu:\ -recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*ruonce*" }
# }

# Exit-PSSession

#--------------------------------------------------------------------------------------------------------------------
#��������� ���������� �� �� �������� ������ Teams
SendMessage "����� Teams ����������� ������ ������� ������� (Vitaliy Kobzar) � �����������."