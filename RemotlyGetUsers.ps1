$s = new-pssession -computer ttsarenko, iplushko
$sb = ${function:Get-localuser}

invoke-command -scriptblock {Get-localuser} -session $s | select * -exclude RunspaceID | out-gridview -title "Local"

pause