Function Global:Set-LocalAdminGroupMembership
{


    <#
    .Synopsis

    .Description

    .Parameter $ComputerName,

    .Example
     PS> Set-LocalAdminGroupMembership -ComputerName $ComputerName -Account 'YourAccount'

    .Link
     about_functions
     about_functions_advanced
     about_functions_advanced_methods
     about_functions_advanced_parameters

    .Notes
     NAME:      Set-LocalAdminGroupMembership
     AUTHOR:    Innotask.com\dmiller
     LASTEDIT:  2/4/2010 2:30:05 PM
     #Requires -Version 2.0
    #>



    [CmdletBinding()]
    param(
    [Parameter(Position=0, ValueFromPipeline=$true)]
    $ComputerName = '.',
    [Parameter(Position=1, Mandatory=$true)]
    $Account
    )


    Process
    {  

        if($ComputerName -eq '.'){$ComputerName = (get-WmiObject win32_computersystem).Name}    
        $ComputerName = $ComputerName.ToUpper()


        $Domain = $env:USERDNSDOMAIN

        if($Domain){
            $adsi = [ADSI]"WinNT://$ComputerName/administrators,group"
            $adsi.add("WinNT://$Domain/$Account,group")
            }else{
            Write-Host "Not connected to a domain." -foregroundcolor "red"
            }


    }# Process


}# Set-LocalAdminGroupMembership