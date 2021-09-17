function Start-PSAdmin {
	Start-Process PowerShell -Verb RunAs -ArgumentList ('-file -noexit "{0}"' -f $PSCommandPath)
}

function IsUserAdmin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  return $boolResult
}

#если юзер не админ, то запускаемся с повышенными привелегиями
if ((IsUserAdmin) -eq $false) {
	Start-PSAdmin
	exit
}

Clear-Host
######################################################################

Add-VpnConnection -Name "Kharkiv" `
-ServerAddress "vpn-ua.intetics.com" `
-TunnelType L2TP `
-L2tpPsk "veRT1xboctkA%^$" `
-Force `
-AuthenticationMethod MSChapv2 `
-SplitTunneling `
-EncryptionLevel "Optional" `
-DnsSuffix "intetics.com.ua" `
-AllUserConnection `
-PassThru


#"Register this connection's addresses in DNS" <- can this be set with Powershell?
#http://www.powershellpro.com/powershell-tutorial-introduction/powershell-wmi-methods/

$nics = Get-WmiObject "Win32_NetworkAdapterConfiguration where IPEnabled='TRUE'"

foreach($nic in $nics)
{
	$nic.SetDynamicDNSRegistration($true)
}

# clear-history 
# Alt + F7

#################################################################################
#Добавьте ярлык пакетного файла VPN на рабочий стол
#Вы также можете настроить пакетный файл, который подключается к вашей VPN, и добавить его на рабочий стол Windows в качестве ярлыка VPN. Чтобы настроить пакетный файл, сначала нажмите кнопку Cortana на панели задач.
#Введите ключевое слово «Блокнот» в поле поиска.
#Выберите, чтобы открыть Блокнот.
#Теперь скопируйте текст ниже с помощью сочетания клавиш Ctrl + C:
@echo off
Ipconfig | find /I "myvpn" && rasdial myvpn /disconnect || rasdial myvpn

#Вставьте текст в Блокнот, нажав горячую клавишу Ctrl + V.

##################################################################################
#rasdial vpn-bpo v.kobzar *
#rasphone vpn-bpo
 
#Посмотреть номер интерфейса
#netsh int ip show interfaces

#показать интерфейсы и выбрать из результата все где есть слово face
#Get-NetIPAddress -AddressFamily ipv4 | Format-List *face*
#$selectedItem = Get-NetIPAddress -AddressFamily ipv4 | Out-GridView
route print 

# -p для постоянных маршрутов
set interface=40

route add 172.20.0.0 MASK 255.255.0.0 192.168.101.5 if %interface% -p
route add 172.16.0.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 10.252.5.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 10.223.1.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.12.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.13.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 10.222.182.0 MASK 255.255.254.0 192.168.101.5 if %interface% -p
route add 192.168.101.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.110.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.124.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.126.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.130.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 172.24.0.0 MASK 255.255.0.0 192.168.101.5 if %interface% -p
route add 172.16.24.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 172.30.0.0 MASK 255.255.0.0 192.168.101.5 if %interface% -p
route add 192.168.2.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.3.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.4.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.107.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.117.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.127.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.137.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p
route add 192.168.177.0 MASK 255.255.255.0 192.168.101.5 if %interface% -p


#rasdial vpn-bpo /disconnect

#route delete 172.20.0.0 MASK 255.255.0.0 192.168.101.5
#route delete 172.16.0.0 MASK 255.255.255.0 192.168.101.5
#route delete 10.252.5.0 MASK 255.255.255.0 192.168.101.5
#route delete 10.223.1.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.12.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.13.0 MASK 255.255.255.0 192.168.101.5
#route delete 10.222.182.0 MASK 255.255.254.0 192.168.101.5
#route delete 192.168.101.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.110.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.124.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.126.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.130.0 MASK 255.255.255.0 192.168.101.5
#route delete 172.24.0.0 MASK 255.255.0.0 192.168.101.5
#route delete 172.16.24.0 MASK 255.255.255.0 192.168.101.5
#route delete 172.30.0.0 MASK 255.255.0.0 192.168.101.5
#route delete 192.168.2.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.3.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.4.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.107.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.117.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.127.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.137.0 MASK 255.255.255.0 192.168.101.5
#route delete 192.168.177.0 MASK 255.255.255.0 192.168.101.5
