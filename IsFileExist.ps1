Clear-Host
$Computers = Get-Content -Path "D:\OneDrive - Intetics Inc\PowerShell\hostsList.txt" # Массив с именами машин (строится из файла)
 
foreach ($remoteHost in $Computers)
{
      if (test-path -path "\\$remoteHost\D`$\vpn") 
      {
            Write-Host "$remoteHost Есть файл VPN " -ForegroundColor Green
      }
      else
      { 
           Write-Host "$remoteHost Нет такого файла" -ForegroundColor Red
      }
}