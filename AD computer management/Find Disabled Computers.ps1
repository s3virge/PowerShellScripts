Search-ADAccount -ComputersOnly -AccountDisabled |sort LastLogonDate | Select Name,LastLogonDate,DistinguishedName |out-gridview -title "Disabled Computers"
pause