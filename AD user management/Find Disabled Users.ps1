Search-ADAccount -UsersOnly -AccountDisabled |sort LastLogonDate | Select Name,LastLogonDate,DistinguishedName |out-gridview -title "Disabled Users"

pause