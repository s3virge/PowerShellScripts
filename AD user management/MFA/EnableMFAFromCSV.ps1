$script = $PSScriptRoot + "\mfastatus.csv" 

# Get-MsolUser -EnabledFilter EnabledOnly
Connect-MsolService -ErrorAction Stop

$result = Import-Csv $script 

$result | ForEach-Object {
  try {
    if ($_.UserPrincipalName -ne "" -and $_.MFAEnabled -eq "FALSE") {      
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