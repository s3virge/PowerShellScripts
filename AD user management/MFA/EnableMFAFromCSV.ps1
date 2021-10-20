$script = $PSScriptRoot + "\mfastatus.csv" 

Write-host "In CSV need to change ; to ," -BackgroundColor Red

# Get-MsolUser -EnabledFilter EnabledOnly
#Connect-MsolService -ErrorAction Stop

#Get-Content $script

Write-host "Replace ; by , in $script" -ForegroundColor Green
((Get-Content -path $script -Raw) -replace ';', ',') | Set-Content -Path $script

#Need to exclude from file
# dbtopbi	dbtopbi@intetics.com	-	False		-
# Intetics Azure	intetics-azure@intetics.com	-	False		-
# Kharkiv Meeting Room Italy	Kharkiv_Meeting_Room_Italy@intetics.com	-	False		-
# Krakow Meeting Room	Krakow_Meeting_Room@intetics.com	-	False		-
# Kyiv Meeting Room L (Large)	Kyiv_Meeting_Room_A@intetics.com	-	False		-
# Library	library@intetics.com	-	False		-
# Minsk Meeting Room 1 (A12 Chicago)	Minsk-MeetingRoom1@intetics.com	-	False		-
# Minsk Meeting Room 4 (B02 Kiev)	Minsk-MeetingRoom4@intetics.com	-	False		-
# onboarding	onboarding@intetics.com	-	False		-
# PBI	pbi@intetics.com	-	False		-
# rpabot	rpabot@intetics.com	-	False		-
# SPOAppraisalsPublisher	spoappraisalspublisher@intetics.com	-	False		-
# HelpDesk	spohelpdeskpublisher@intetics.com	-	False		-
# Intetics StayCool	StayCool@intetics.com	-	False		-
# vrf_info	vrf_info@intetics.com	-	False		-

$result = Import-Csv $script 

$result | ForEach-Object {
  try {
    
    #Write-host $_
    
    if ($_.UserPrincipalName -ne "" -and $_.MFAEnabled -eq "FALSE" -and $_.MFAEnforced -eq "-") {
      #if ($_.Column2 -ne "" -and $_.Column4 -eq "FALSE" -and $_.Column6 -eq "-") {      
      #$upn = $_.Column2
      $upn = $_.UserPrincipalName
      
      # Create the StrongAuthenticationRequirement Object
      $sa = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
      $sa.RelyingParty = "*"
      $sa.State = "Enabled"
      $sar = @($sa)
      # Enable MFA for the user
      Set-MsolUser -UserPrincipalName $upn -StrongAuthenticationRequirements $sar

      Write-host "For $upn MFA has been turned ON" -ForegroundColor Green
    }
  }
  catch {
    Write-Host "$upn $_" -ForegroundColor Red
  } 
}