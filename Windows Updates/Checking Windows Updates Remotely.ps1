function Get-SoftwareUpdate {
  param(
  $ComputerName, 
  $Credential
  )

  $code = {
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Searcher = $Session.CreateUpdateSearcher()
    $HistoryCount = $Searcher.GetTotalHistoryCount()
    $Searcher.QueryHistory(1,$HistoryCount) | 
      Select-Object Date, Title, Description
  } 

  $pcname = @{
    Name = 'Machine'
    Expression = { $_.PSComputerName }
  }

  Invoke-Command $code @psboundparameters | 
    Select-Object $pcname, Date, Title, Description
}