�������� ������� � PowerShell
����� ���� � �������� PowerShell-������:

PS C:\> (Get-PSReadlineOption).HistorySavePath

�������� ���������� ����� � �������� PowerShell-������:
PS C:\> cat (Get-PSReadlineOption).HistorySavePath

�������� ������� ������ � PowerShell, ������ ���� � ��������:
PS C:\> Remove-Item (Get-PSReadlineOption).HistorySavePath