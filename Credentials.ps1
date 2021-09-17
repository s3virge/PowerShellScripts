$remoteKeyParams = @{
    ComputerName = $env:COMPUTERNAME
    Path = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
    Name = 'EnableRemoteManagement'
    Value = '1' 
    }

    function Set-RemoteRegistryValue {
        param(
            $ComputerName,
            $Path,
            $Name,
            $Value,
            [ValidateNotNull()]
            [System.Management.Automation.PSCredential]
            [System.Management.Automation.Credential()]
            $Credential = [System.Management.Automation.PSCredential]::Empty        
        )
    
        if($Credential -ne [System.Management.Automation.PSCredential]::Empty) {
            Invoke-Command -ComputerName:$ComputerName -Credential:$Credential  {
                Set-ItemProperty -Path $using:Path -Name $using:Name -Value $using:Value
            }
        } else {
            Invoke-Command -ComputerName:$ComputerName {
                Set-ItemProperty -Path $using:Path -Name $using:Name -Value $using:Value
            }
        }
    }
    
    Set-RemoteRegistryValue @remoteKeyParams -Credential (Get-Credential)

    # зайти с указанным пользователем duffney
    Set-RemoteRegistryValue @remoteKeyParams -Credential duffney