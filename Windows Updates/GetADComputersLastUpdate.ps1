$adHosts = @() 
 
Get-ADComputer -Filter {(Enabled -eq $True)} -Properties * | Select-Object Name | ForEach-Object {
    #if ((Test-Connection -computer $_ -quiet) -eq $True)
    #{ 
		Write-Host $_.Name
        # Add the current name to the array 
        $adHosts += $_.Name 
    #} 
} 

cls

foreach ($comp in $adHosts ) { 
    if ((Test-Connection -computer $comp -quiet) -eq $True) {
        try {
            $cmd = {
                (Get-ItemProperty `
                    -Path ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" + `
                          "\WindowsUpdate\Auto Update\Results\Install") `
                    -Name "LastSuccessTime"
                ).LastSuccessTime
            }
        
            #$result = Invoke-Command -ComputerName $comp -ScriptBlock $cmd -ErrorAction SilentlyContinue
            #$result

            $result = Invoke-Command -ComputerName $comp -ScriptBlock { (New-Object -com "Microsoft.Update.AutoUpdate").Results.LastInstallationSuccessDate} -ErrorAction SilentlyContinue
            
            if(!$result){
                Write-Host $comp ( " " * (20 - $comp.Length) ) "Failed" -ForegroundColor Red
        
            }
            else{
                Write-Host $comp ( " " * (20 - $comp.Length) ) "Updates were installed: " $result
            }            
        
            #$key = "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install"
            #$keytype = [Microsoft.Win32.RegistryHive]::LocalMachine 
            #$RemoteBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype, $comp) 
            #$regKey = $RemoteBase.OpenSubKey($key) 
            #$KeyValue = $regkey.GetValue("LastSuccessTime")       
     
            #$System = (Get-Date -Format "dd-MM-yyyy hh:mm:ss")  
    
            #if ($KeyValue -lt $System) {
            #    Write-Host $comp "Updates were installed: " $KeyValue 
            #}
        }
        catch {
            Write-Host $comp ( " " * (20 - $comp.Length) ) "Failed: $($_.Exception.Message)" -ForegroundColor Red
        } 
    }	
    else {
            Write-Host $comp ( " " * (20 - $comp.Length) ) "is unreachable" -ForegroundColor Red
    }
}
