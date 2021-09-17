##################################################################################################################
import-module activedirectory

$adUserName = "l.vnuchenko"
$fileRath = "d:\" + $adUserName + "_MemberOf.csv"

Get-ADPrincipalGroupMembership $adUserName | select name | export-csv $fileRath 

##################################################################################################################
$adUserName = "l.vnuchenko"
$fileRath = "d:\" + $adUserName + "_MemberOf.csv"

get-aduser $adUserName -Properties memberof | select -expand memberof
##################################################################################################################
(GET-ADUSER –Identity "I.Zhukova" –Properties MemberOf | Select-Object MemberOf).MemberOf

##################################################################################################################
Get-ADPrincipalGroupMembership "E.Kalyazin"

##################################################################################################################
#import-module activedirectory

#$adUserName = Read-Host 'Please enter Username!'
#$adUserName = "I.Zhukova"
#$adUserName = "V.Kobzar"
$adUserName = "E.Kalyazin"
Get-ADPrincipalGroupMembership $adUserName | Get-ADGroup -Properties * | select name, description

$adUserName = "I.Zhukova"
$fileRath = "d:\" + $adUserName + "_MemberOf.csv"
Get-ADPrincipalGroupMembership $adUserName | select name | export-CSV $fileRath

$adUserName = "E.Bokova"
$fileRath = "d:\" + $adUserName + "_MemberOf.csv"
Get-ADPrincipalGroupMembership $adUserName | select name | export-CSV $fileRath

$adUserName = "gis-project1"
$fileRath = "d:\" + $adUserName + "_MemberOf.csv"
Get-ADPrincipalGroupMembership $adUserName | select name | export-CSV $fileRath

pause