set fileName=mfastatus.csv
set filepath='%~dp0%fileName%'
::set folderPath=%~dp0

:: excl умеет работать только если в качестве разделителя ;
:: А для POwerShel уже нужен разделитель ,

powershell ".\GetMFAStatus.ps1" "|Export-CSV %filepath% -Delimiter ';'"
::powershell ".\GetMFAStatus.ps1" "-withOutMFAOnly | Export-CSV %filepath% -Delimiter ','"

start "" %fileName%

::pause