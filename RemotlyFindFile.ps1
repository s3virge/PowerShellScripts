$Rechnerliste="kobzar"

Foreach ($Rechner in (get-Content $Rechnerliste))
{
	"Beginne mit Rechner " + $Rechner 
    $pfad = "\\" + $Rechner + "\d$\"

    $Files = @(Get-ChildItem $pfad -Recurse | Where-Object {$_.Extension -eq ".ps1"})
        
    if ($Files.length -eq 0) {
	}
    else {
        Add-Content -Path "d:\ComputerMitBBA.txt" -Value $Rechner     
        continue 
	}
}
	