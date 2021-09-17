# Write-Host "Script:" $PSCommandPath
Write-Host "Path:" $PSScriptRoot

$serviceName = "chromoting"

$TXTFileName = $PSScriptRoot + "\InteticsADComputersList.txt"
$csvFileName = $PSScriptRoot + "\Computers_With_$serviceName" + "_service.csv"

# Get-ADComputer -Filter * -Properties * | select-object name, whenCreated, whenChanged, canonicalName, OperatingSystem, IPv4Address, enabled | Export-Csv $fileName

#Get-ADComputer -Filter {(Enabled -eq $True)} -Properties * | Select-Object Name | Format-Table -AutoSize | Out-String -Width 4096 | Out-File $TXTFileName
Get-ADComputer -Filter {(Enabled -eq $True)} -Properties * | Select-Object Name | Format-Table -AutoSize | Out-File $TXTFileName
$computers = Get-Content -Path $TXTFileName
$message = ""
$message | Out-File $csvFileName -Encoding UTF8

foreach( $comp in $computers){
    $comp = $comp.Trim();

    if ($comp -eq "" -or $comp -eq "Name" -or $comp -eq "----") {
        continue
    }
    
    #проверить доступность компа    
    if ((Test-Connection -computer $comp -quiet) -eq $True)
    {
		Write-Host "$comp is accessible. " -ForegroundColor Green -NoNewline
		Invoke-Command -ComputerName $comp -ScriptBlock { (New-Object -com "Microsoft.Update.AutoUpdate").Results.LastInstallationSuccessDate} -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "$comp is unreachable" -ForegroundColor Red
    }

    $message | Out-File $csvFileName -Append -Encoding UTF8
}
 
pause