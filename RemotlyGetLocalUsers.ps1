& "$PSScriptRoot\GetADUserInfo.ps1";

write-host "--------------------------------------"
$remotePCName = read-host "Enter computer name"

###################################################################################
# $remotePCName = read-Host "Enter computer name"

# $remotePCName = "KHARCHEVNIKOVA"
# $remotePCName = "YVDOVITSA"
# $remotePCName = "TTSARENK"
# $remotePCName = "DCHUMAK"
#$remotePCName = "EKUTSENK"

# добавляет в ветку реестра на удалённом компе скрипт в автозагрузку
# reg add "\\$remotePCName\$regKey" /v $regKeyName /t $regKeyType /d $regKeyValue
# Invoke-Command –ComputerName $remotePCName –ScriptBlock { Get-Item -Path $regKey }

Invoke-Command -ComputerName $remotePCName -ScriptBlock { net localgroup Administrators }

#$remotePCName = "TTSARENKo"
#Get-PSSession -ComputerName $remotePCName -Credential v.kobzar

$session = New-PSSession -ComputerName $remotePCName
Enter-PSSession -Session $session

# net localgroup Administrators - get list of local admins
# net localgroup Administrators %username% /delete

#  Exit-PSSession

######################################################################################


# $pcName = Read-Host "Enter computer name"
# $pcName = "KUZNETSOV"

<# 
The big difference is where the job runs. 
By using Start-Job, it runs locally and the code in the script block handles the connectivity. 
By using Invoke-Command, the job runs on the remote machine, but the results come back to the local machine. 
#>

# Invoke-Command -AsJob -ComputerName ($env:COMPUTERNAME) -ScriptBlock { Get-ChildItem -Recurse $using:source |  Get-DfsrFileHash | Export-csv -Append C:\Temp\Test_Source_Checksum.csv }

# $jobId = Start-Job -ScriptBlock { Get-PSDrive -ComputerName $pcName }

# Get-Job
# Receive-Job -id $jobId -Keep
# Exit-PSSession

####################################################################################
<# 
    На диске С$ указанного компьютера создаём PowerShell файл который будет выполняться на этом компе
#>
# start remote session
# $session = New-PSSession -ComputerName $pcName
# Enter-PSSession -Session $session

# $sess | Remove-PSSession
# Exit-PSSession


###################################################################################
# Invoke-Command -ComputerName $pcName -ScriptBlock { Stop-Process -Name "teams"} -credential v.kobzar
# Invoke-Command -ComputerName $pcName -ScriptBlock { gpupdate /force } -credential v.kobzar
# Invoke-Command -ComputerName $pcName -ScriptBlock { Get-Process} <# -credential v.kobzar #>

# Enter-PSSession -ComputerName $pcName -Credential v.kobzar

<# Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe" -ArgumentList "--processStart", "Teams.exe"
Exit-PSSession #>

###################################################################################
# $remotePCName = read-Host "Enter computer name"

# $remotePCName = "KHARCHEVNIKOVA"
# $remotePCName = "YVDOVITSA"
# $remotePCName = "TTSARENK"
# $remotePCName = "DCHUMAK"
# $remotePCName = "EKUTSENK"
$remotePCName = "MLugin2"

# добавляет в ветку реестра на удалённом компе скрипт в автозагрузку
# reg add "\\$remotePCName\$regKey" /v $regKeyName /t $regKeyType /d $regKeyValue
# Invoke-Command –ComputerName $remotePCName –ScriptBlock { Get-Item -Path $regKey }

#Invoke-Command -ComputerName $remotePCName -ScriptBlock { net localgroup Administrators }
# Invoke-Command -ComputerName $remotePCName -ScriptBlock { gpupdate /force }

# Get-PSSession -ComputerName $remotePCName -Credential v.kobzar

$session = New-PSSession -ComputerName $remotePCName
Enter-PSSession -Session $session

#net localgroup Administrators - get list of local admins
# net localgroup Administrators %username% /delete

#  Exit-PSSession

#####################################################################################
Enter-PSSession -ComputerName mlugin2

#  Exit-PSSession


pause