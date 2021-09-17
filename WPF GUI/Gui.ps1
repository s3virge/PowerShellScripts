$inputXML = @"
<Window x:Class="WpfApplication2.MainWindow" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation&quot; xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml&quot; xmlns:d="http://schemas.microsoft.com/expression/blend/2008&quot; xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006&quot; xmlns:local="clr-namespace:WpfApplication2" mc:Ignorable="d" Title="FoxDeploy Awesome Tool" Height="416.794" Width="598.474" Topmost="True">
    <Grid Margin="0,0,45,0">
        <Image x:Name="image" HorizontalAlignment="Left" Height="100" Margin="24,28,0,0" VerticalAlignment="Top" Width="100" Source="C:\Users\Stephen\Dropbox\Docs\blog\foxdeploy favicon.png"/>
        <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Height="100" Margin="174,28,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="282" FontSize="16"><Run Text="Use this tool to find out all sorts of useful disk information, and also to get rich input from your scripts and tools"/><InlineUIContainer>
                <TextBlock x:Name="textBlock1" TextWrapping="Wrap" Text="TextBlock"/>
            </InlineUIContainer></TextBlock>
        <Button x:Name="button" Content="get-DiskInfo" HorizontalAlignment="Left" Height="35" Margin="393,144,0,0" VerticalAlignment="Top" Width="121" FontSize="18.667"/>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" Height="35" Margin="186,144,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="168" FontSize="16"/>
        <Label x:Name="label" Content="ComputerName" HorizontalAlignment="Left" Height="46" Margin="24,144,0,0" VerticalAlignment="Top" Width="138" FontSize="16"/>
        <ListView x:Name="listView" HorizontalAlignment="Left" Height="156" Margin="24,195,0,0" VerticalAlignment="Top" Width="511" FontSize="16">
            <ListView.View>
                <GridView>
                    <GridViewColumn Header="Drive Letter" Width="120"/>
                    <GridViewColumn Header="Drive Label" Width="120"/>
                    <GridViewColumn Header="Size(MB)" Width="120"/>
                    <GridViewColumn Header="FreeSpace%" Width="120"/>
                </GridView>
            </ListView.View>
        </ListView>
 
    </Grid>
</Window>
"@ 
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)

try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
    }
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties (PowerShell cannot process them)"
    throw
    }
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable –Name "WPF$($_.Name)" –Value $Form.FindName($_.Name) –ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" –ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" –ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================
                                                                    
     
#Reference 
 
#Adding items to a dropdown/combo box
#$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
#$WPFtextBox.Text = $env:COMPUTERNAME
     
#Adding code to a button, so that when clicked, it pings a system
# $WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text
# })
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" –ForegroundColor Cyan
'$Form.ShowDialog() | out-null'