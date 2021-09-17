@echo off
cls

::if Windows XP	 version = 5.1.2600 then go to the run
::If the version was successfully displayed %ERRORLEVEL% = 0
::If a bad parameter is given %ERRORLEVEL% = 1

ver | find "5.1" > nul && if %ERRORLEVEL% == 0 goto :run

ver |>NUL find /v "5." && if "%~1"=="" (
  Echo CreateObject^("Shell.Application"^).ShellExecute WScript.Arguments^(0^),"1","","runas",1 >"%~dp0Elevating.vbs"
  cscript.exe //nologo "%~dp0Elevating.vbs" "%~f0" & goto :eof
)
del %~dp0Elevating.vbs

:run

set batchPath=%~dp0
powershell.exe -ExecutionPolicy Bypass -noexit -file "%batchPath%\CreateLotOfUsersFromCSV.ps1"
