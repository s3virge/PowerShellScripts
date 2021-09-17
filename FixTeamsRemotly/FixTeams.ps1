$teamID = Get-Process -Name "Teams"

if ($teamID.Count -gt 0 ) {
    Stop-Process -Name "teams"
}

Remove-Item -Path "$env:APPDATA\Microsoft\Teams\desktop-config.json" 
Remove-Item -Path "$env:APPDATA\Microsoft\Teams\settings.json" 
Remove-Item -Path "$env:APPDATA\Microsoft\Teams\storage.json" 

Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe" -ArgumentList "--processStart", "Teams.exe"