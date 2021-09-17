Очистить Историю в PowerShell
Найти файл с историей PowerShell-команд:

PS C:\> (Get-PSReadlineOption).HistorySavePath

Показать содержимое файла с историей PowerShell-команд:
PS C:\> cat (Get-PSReadlineOption).HistorySavePath

Очистить историю команд в PowerShell, удалив файл с историей:
PS C:\> Remove-Item (Get-PSReadlineOption).HistorySavePath