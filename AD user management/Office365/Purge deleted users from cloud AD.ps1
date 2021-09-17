
# function Start-PSAdmin {
	# Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
# }

# function IsUserAdmin {
  # $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  # $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
  # return $boolResult
# }

# #если юзер не админ, то запускаемся с повышенными привелегиями
# if ((IsUserAdmin) -eq $false) {
	# Start-PSAdmin
	# exit
# }

# Install-Module MSOnline

# # тут можно вписать свой логин и пароль что бы не запрашивало креды
# $username = "admin@domain.com"
# $password = ConvertTo-SecureString "mypassword" -AsPlainText -Force
# $psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
# Connect-MsolService -Credential $psCred -ErrorAction Stop

$username = "vvk_adm@intetics.com"
#$credential = Get-Credential $username
Connect-MsolService -Credential $credential -ErrorAction Stop

Write-Warning ("Сейчас на экране появится таблица с пользователями из корзины облачного AD, где будет необходимо выбрать тех пользователей, которых необходимо окончательно удалить")
# Read-Host "Для продолжения нажмите Enter"
Get-MsolUser –ReturnDeletedUsers | Out-GridView -Title Deleted_Users -PassThru | Remove-MsolUser -RemoveFromRecycleBin
Start-Sleep -s 1
Write-Output ("Всё готово!")