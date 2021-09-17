$OUpath = 'OU=HERE_Temp,OU=Coders,OU=GIS,OU=Personnel,DC=intetics,DC=com,DC=ua'
$ExportPath = 'D:\OneDrive - Intetics Inc\PowerShell\AD user management\users_in_ou1.csv'
Get-ADUser -Filter * -SearchBase $OUpath | Export-Csv -NoType $ExportPath -Delimiter ";"