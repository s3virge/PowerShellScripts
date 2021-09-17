function Start-PSAdmin {
	Start-Process PowerShell -Verb RunAs -ArgumentList ('-file "{0}"' -f $PSCommandPath)
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
########################################################################################################################
# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

############################################################################

function AddToSubcontractorsGroups {
  param (
    $UserName
  )
  
  #intetics.com.ua/Groups/Global/
  $identity = "cn=g_subcontractors, ou=Global, ou=Groups, DC=intetics, dc=com, dc=ua"
  Add-ADGroupMember -Identity $identity -Members $UserName
}

function AddToDevelopersGroups {
  param (
    $UserName
  )

  $identity = "cn=g_developers, ou=Global, ou=Groups, DC=intetics, dc=com, dc=ua"  
  Add-ADGroupMember -Identity $identity -Members $UserName
  
  $identity = "cn=Ukraine All, ou=Mail, OU=Personnel, DC=intetics, DC=com, DC=ua"
  Add-ADGroupMember -Identity $identity -Members $UserName
  
  $identity = "cn=Kh_Developers, ou=Mail, OU=Personnel, DC=intetics, DC=com, DC=ua"
  Add-ADGroupMember -Identity $identity -Members $UserName
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(532,360)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$tbUserName                      = New-Object system.Windows.Forms.TextBox
$tbUserName.multiline            = $false
$tbUserName.width                = 206
$tbUserName.height               = 20
$tbUserName.location             = New-Object System.Drawing.Point(150,31)
$tbUserName.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$btnAdd                          = New-Object system.Windows.Forms.Button
$btnAdd.text                     = "Add"
$btnAdd.width                    = 60
$btnAdd.height                   = 30
$btnAdd.location                 = New-Object System.Drawing.Point(189,298)
$btnAdd.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "User name"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(61,34)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$tbPassword                      = New-Object system.Windows.Forms.TextBox
$tbPassword.multiline            = $false
$tbPassword.width                = 206
$tbPassword.height               = 20
$tbPassword.location             = New-Object System.Drawing.Point(151,64)
$tbPassword.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$tbPassword.text				 = "@RK5jsAVa"

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Passwrod"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(61,64)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$btnCancel                       = New-Object system.Windows.Forms.Button
$btnCancel.text                  = "Exit"
$btnCancel.width                 = 60
$btnCancel.height                = 30
$btnCancel.location              = New-Object System.Drawing.Point(279,298)
$btnCancel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$btnCancel.DialogResult          = [System.Windows.Forms.DialogResult]::Cancel

$rbPersonel                      = New-Object system.Windows.Forms.RadioButton
$rbPersonel.text                 = "Personel"
$rbPersonel.AutoSize             = $true
$rbPersonel.width                = 104
$rbPersonel.height               = 20
$rbPersonel.location             = New-Object System.Drawing.Point(94,131)
$rbPersonel.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$rbPersonel.Checked              = $true

$rbSubcontractor                 = New-Object system.Windows.Forms.RadioButton
$rbSubcontractor.text            = "Subcontractor"
$rbSubcontractor.AutoSize        = $true
$rbSubcontractor.width           = 104
$rbSubcontractor.height          = 20
$rbSubcontractor.location        = New-Object System.Drawing.Point(93,161)
$rbSubcontractor.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$rbDeveloper                     = New-Object system.Windows.Forms.RadioButton
$rbDeveloper.text                = "Developer"
$rbDeveloper.AutoSize            = $true
$rbDeveloper.width               = 104
$rbDeveloper.height              = 20
$rbDeveloper.location            = New-Object System.Drawing.Point(95,192)
$rbDeveloper.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LblMessage                      = New-Object system.Windows.Forms.Label
$LblMessage.text                 = ""
$LblMessage.AutoSize             = $true
$LblMessage.width                = 52
$LblMessage.height               = 10
$LblMessage.location             = New-Object System.Drawing.Point(93,245)
$LblMessage.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LblMessage.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#f10b0b")

$LinkLabel = New-Object System.Windows.Forms.LinkLabel 
$LinkLabel.Location = New-Object System.Drawing.Size(39,235) 
$LinkLabel.Size = New-Object System.Drawing.Size(150,20) 
$LinkLabel.LinkColor = "BLUE" 
$LinkLabel.ActiveLinkColor = "RED" 
$LinkLabel.Text = "Create e-mail" 
$LinkLabel.add_Click({[system.Diagnostics.Process]::start("https://mail.intetics.com/ecp/")}) 
$Form.Controls.Add($LinkLabel) 

$LinkLabel2 = New-Object System.Windows.Forms.LinkLabel 
$LinkLabel2.Location = New-Object System.Drawing.Size(39,260) 
$LinkLabel2.Size = New-Object System.Drawing.Size(150,20) 
$LinkLabel2.LinkColor = "BLUE" 
$LinkLabel2.ActiveLinkColor = "RED" 
$LinkLabel2.Text = "Migrate to cloud" 
$LinkLabel2.add_Click({[system.Diagnostics.Process]::start("https://outlook.office365.com/ecp/")}) 
$Form.Controls.Add($LinkLabel2)

$Form.controls.AddRange(@($tbUserName,$btnAdd,$Label1,$tbPassword,$Label2,$btnCancel,$rbPersonel,$rbSubcontractor,$rbDeveloper,$LblMessage))

$btnAdd.Add_Click({ OnClickBtnAdd })
# $btnCancel.Add_Click({ OnClickBtnCancel })

function OnClickBtnAdd {
  #$userFullName = Read-Host -Prompt "Input full user login"
  $userFullName = $tbUserName.text
  
  #Check if the user account already exists in AD
  if (Get-ADUser -F { Name -eq $userFullName }) {
    #If user does exist, output a warning message
    # Write-Warning "A user account $userFullName has already exist in Active Directory."
    $LblMessage.Text = "A user account $userFullName has already exist in Active Directory."    
  }
  else {
    $splitedFullName = $userFullName.Split(" ");
    $givenName = $splitedFullName[0]
    $surName = $splitedFullName[1]
    $samAccountName = $givenName.Substring(0, 1).ToLower() + "." + $surName.ToLower()
    $principalName = "$samAccountName@intetics.com"
    $department = ""
    #$password = Read-Host -Prompt "Input password" -AsSecureString
    #$password = Read-Host -Prompt "Input password" 
    $password = $tbPassword.Text
    
    $path = ""

    if( $rbPersonel.Checked){
          $path = "OU=Personnel,DC=intetics,DC=com,DC=ua"
        }
        elseif($rbDeveloper.Checked){
          $path = "OU=Developers,OU=Personnel,DC=intetics,DC=com,DC=ua"
        }
        elseif($rbSubcontractor){
          $path = "OU=Subcontractors,OU=Personnel,DC=intetics,DC=com,DC=ua"
        }
      
    #New-ADUser -Name "Jack Robinson" -GivenName $givenName -Surname $surName -SamAccountName "J.Robinson" -UserPrincipalName "J.Robinson@enterprise.com" -Path "OU=Managers,DC=enterprise,DC=com" -AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true
  
    New-ADUser -Name $userFullName `
      -GivenName $givenName `
      -Surname $surName `
      -SamAccountName $samAccountName `
      -UserPrincipalName $principalName `
      -Path $path `
      -Department $department `
      -AccountPassword (ConvertTo-SecureString $password -AsPlainText -force) `
      -Enabled $true `
      -ChangePasswordAtLogon $true

      if( $rbPersonel.Checked){
        
      }
      elseif($rbDeveloper.Checked){
        AddToDevelopersGroups -UserName "cn=$userFullName, $path"
      }
      elseif($rbSubcontractor){
        AddToSubcontractorsGroups -UserName "cn=$userFullName, $path"
      }

    #$LblMessage.Text = "The user account $userFullName was created in Active Directory."
    [System.Windows.Forms.MessageBox]::Show("The user account $userFullName was created in Active Directory." , "Great")    
  }  
} 
  
[void]$Form.ShowDialog()
