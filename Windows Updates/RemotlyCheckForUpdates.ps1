#после запуска в Windows Update видно что выполняется поиск обновлений.
#Invoke-Command -ComputerName ARCGIS -ScriptBlock { usoclient.exe ScanInstallWait } -credential vvk_adm

#тут ничего не видно
Invoke-Command -ComputerName ARCGIS -ScriptBlock { wuauclt /detectnow /updatenow } -credential vvk_adm
pause