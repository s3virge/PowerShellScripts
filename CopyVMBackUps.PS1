function Start-PSAdmin {
 	Start-Process PowerShell -Verb RunAs -ArgumentList ('-noexit -file "{0}"' -f $PSCommandPath)
     #Start-Process PowerShell -Verb RunAs -ArgumentList ('-file "{0}"' -f $PSCommandPath)
}

function IsUserAdmin {
   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
   $boolResult = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
   return $boolResult
}

if ((IsUserAdmin) -eq $false) {
 	Start-PSAdmin
	exit
}

Clear-Host

#############################################################################################

function DeleteFolder {
    param (
           $FolderPath
    )   
    
    try {
        Remove-Item -path $FolderPath -recurse -force -ErrorAction Stop
        Write-Host "`n  Folder $FolderPath was deleted  " -ForegroundColor red
    }
    catch {
        Write-Host "  Delete folder error  `n" $_.Exception.Message -ForegroundColor red
    }
}

function CopyNewestFolder {
param (
   $FromFolder,
   $ToFolder        
)

$childs = Get-ChildItem $FromFolder | Sort-Object -Property LastWriteTime -Descending   

$theNewestFolder = ($childs | Select-Object -First 1).Name

Copy-Item -Path "$FromFolder\$theNewestFolder" -Destination "$ToFolder\$theNewestFolder" -Recurse -PassThru
}

#I wrote this method to copy files using Explorer's Shell (represented as a COM object)
#Replacing CopyHere with MoveHere will trigger a move operation instead.
function Copy-ItemUsingExplorer {
param(
   [string]$source,
   [string]$destination,
   [int]$CopyFlags
)

$objShell = New-Object -ComObject 'Shell.Application'
$objFolder = $objShell.NameSpace((Get-Item $destination).FullName)
$objFolder.CopyHere((Get-Item $source).FullName,$CopyFlags.ToString('{0:x}'))
}

function CopyFolders {
   param (
      $ListOfFolders,
      $FromFolder,
      $ToFolder
   )

   foreach ($folder in $ListOfFolders) {
      $CopyFromFolderPath = "$FromFolder\$folder"
      $CopyToFolderPath = "$ToFolder\$folder"    

      DeleteFolder -FolderPath $CopyToFolderPath
      CopyNewestFolder -FromFolder $CopyFromFolderPath -ToFolder $CopyToFolderPath
   }
}

$CopyingStarted = Get-Date -Format "HH:mm:ss"

#############################################################################################

$FoldersList = 
"kbeobachter", 
"kcloud"

$pathToFromFolder = "\\kstore\E$\Storage"
# $pathToFromFolder = "e:\Storage"

$DriveLetterOfToFolder = "D:"
$DriveLetterOfToFolder = "F:"

$From = "$pathToFromFolder\unix"
$To = "$DriveLetterOfToFolder\unix"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

CopyFolders -ListOfFolders $FoldersList -FromFolder $From -ToFolder $To

#############################################################################################

$FoldersList = 
"kpbx"

$From = "$pathToFromFolder\unix"
$To = "$DriveLetterOfToFolder\unix"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

foreach ($folder in $FoldersList) {
   $CopyToFolderPath = "$To\$folder"
   $CopyFromFolderPath = "$From\$folder"

   DeleteFolder -FolderPath $CopyToFolderPath
   Copy-Item -Path $CopyFromFolderPath -Destination $CopyToFolderPath -Recurse -PassThru
}

#############################################################################################

$FoldersList =
"KACS",
"KGUARD",
"KH-GIS-DNSFWD",
"KH-BPO-MONITOR",
"KH-GIS-iPROXY",
"KH-GIS-PROXY",
"KH-GIS-SRV01",
"KNPS",
"KRAS",
"KV-ACS",
"KV-VPN",
"KWSUS",
"LVACS",
"LV-SRV-01",
"kdc4"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

foreach ($folder in $FoldersList) {
   $CopyToFolderPath = "$DriveLetterOfToFolder\vm\$folder"
   $CopyFromFolderPath = "$pathToFromFolder\vm\$folder\"

   DeleteFolder -FolderPath $CopyToFolderPath
   Copy-Item -Path $CopyFromFolderPath -Destination $CopyToFolderPath -Recurse -PassThru
}

#############################################################################################

$FoldersList = "KSTORE"
$From = "$pathToFromFolder\windows"
$To = "$DriveLetterOfToFolder\windows"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

CopyFolders -ListOfFolders $FoldersList -FromFolder $From -ToFolder $To

#############################################################################################

$FoldersList = 
"KBUH2",
"KDC3",
"KFS2",
"KSTORE",
"KVDC",
"kdc4"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

$From = "$pathToFromFolder\windows-image"
$To = "$DriveLetterOfToFolder\windows-image"

CopyFolders -ListOfFolders $FoldersList -FromFolder $From -ToFolder $To

#############################################################################################

$FoldersList = 
"KDC3",
"KVDC"

Write-Host "`n  Folders to copy: $FoldersList  `n" -ForegroundColor green

$From = "$pathToFromFolder\windows-systate"
$To = "$DriveLetterOfToFolder\windows-systate"

CopyFolders -ListOfFolders $FoldersList -FromFolder $From -ToFolder $To

#############################################################################

$CopyingFinished = Get-Date -Format "HH:mm:ss"

$MailBody = "Copying the backups to an external drive has completed.`
`n`nCopying was started $CopyingStarted. `
Copying was finished $CopyingFinished."

Send-MailMessage -From 'service-notifier@intetics.com' -To 'v.kobzar@intetics.com' -Subject 'Copy Backup completed' -Body $MailBody -SmtpServer 'mail-ua.intetics.com'
