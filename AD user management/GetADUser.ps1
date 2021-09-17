# Get-ADUser -identity Y.Vitko -properties *

# Get-ADUser -filter * -properties PasswordExpired, PasswordLastSet, PasswordNeverExpires | ft Name, PasswordExpired, PasswordLastSet, PasswordNeverExpires

#Чтобы вывести данные пользователей из определенной OU, воспользуемся параметром SearchBase:
# Get-ADUser -SearchBase ‘OU=Personnel,DC=intetics,DC=com,DC=ua’ -filter * -properties PasswordExpired, PasswordLastSet, PasswordNeverExpires | ft Name, PasswordExpired, PasswordLastSet, PasswordNeverExpires

#Вывод пользователей AD, имя которых начинается с Roman:
# Get-ADUser -filter {name -like "Roman*"}

#Чтобы подсчитать общее количество всех аккаунтов в Active Directory:
# Get-ADUser -Filter {SamAccountName -like "*"} | Measure-Object

# найти пользователя в ад по части мобильного телефона
Get-ADUser -Filter { mobile -like "*1226*" } -Properties mail, mobile | Select-Object Name, mail, mobile

#Список всех активных (не заблокированных) учетных записей в AD:

# Get-ADUser -Filter {Enabled -eq "True"} | Select-Object SamAccountName,Name,Surname,GivenName | Format-Table

#Список учетных записей с истекшим сроком действия пароля:

# Get-ADUser -filter {Enabled -eq $True} -properties passwordExpired | where {$_.PasswordExpired}

#Список активных учеток с почтовыми адресами:
# Get-ADUser -Filter {(mobile -ne "null") -and (Enabled -eq "true")} -Properties Surname,GivenName,mail, mobile | Select-Object Name,Surname,GivenName,mail,mobile | Export-CSV d:\user_ad_list.csv <# -Append #>

#Задача: для списка учетных записей, которые хранятся в текстовом файле (по одной учетке в строке) нужно получить телефон пользователя в AD и выгрузить информацию в текстовый csv файл (можно легко импортировать в Esxel).
<# Import-Csv d:\usernsme_list.csv | 
    ForEach-Object {
        Get-ADUser -identity $_.user -Properties Name, telephoneNumber |
            Select-Object Name, telephoneNumber |
            Export-CSV c:\ps\export_ad_list.csv -Append -Encoding UTF8
    }
 #>
#Следующий пример позволяет выгрузить адресную книгу предприятия в виде csv файла, который в дальнейшем можно импортировать в Outlook или Mozilla Thunderbird:
# Get-ADUser -Filter {(mail -ne "null") -and (Enabled -eq "true")} -Properties Surname,GivenName,mail | Select-Object Name,Surname,GivenName,mail | Export-Csv -NoTypeInformation -Encoding utf8 -delimiter "," $env:temp\mail_list.csv

#Пользователи, которые не меняли свой пароль в течении последних 90 дней:
# $90_Days = (Get-Date).adddays(-90)
# Get-ADUser -filter {(passwordlastset -le $90_days)}

#Чтобы получить фотографию пользователя из Active Directory и сохранить ее в jpg файл:
# $user = Get-ADUser winadmin -Properties thumbnailPhoto
# $user.thumbnailPhoto | Set-Content winadmin.jpg -Encoding byte

#Список групп, в которых состоит учетная запись пользователя
# Get-AdUser winadmin -Properties memberof | Select memberof -expandproperty memberof