@echo off

taskkill /f /im teams.exe
taskkill /f /im update.exe

set teams=""%APPDATA%\Microsoft\Teams""

del /s /q %teams%\desktop-config.json
del /s /q %teams%\settings.json
del /s /q %teams%\storage.json

start """" %LOCALAPPDATA%\Microsoft\Teams\Update.exe --processStart ""Teams.exe"" 

start /b """" cmd /c del ""%~f0""&exit /b

::psexec -u domain\user -p password \\xxx.xxx.xxx.xxx -s cmd /c rd "C:\Documents and Settings\%USERACCOUNT%\Local Settings\Temporary Internet Files\Content.IE5\" /s /q
