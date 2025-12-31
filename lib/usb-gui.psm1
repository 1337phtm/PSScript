Add-Type -AssemblyName PresentationFramework

function Show-UsbWindow {
    param(
        [Parameter(Mandatory)]
        [object[]]$Items
    )

    $XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Gestion des clés USB" Height="600" Width="900"
        WindowStartupLocation="CenterScreen"
        Background="#1E1E1E">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TextBlock Text="Clés USB connues / détectées"
                   Foreground="White"
                   FontSize="22"
                   Margin="0,0,0,10"/>

        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
            <ItemsControl Name="UsbList">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <Border BorderBrush="#444" BorderThickness="1" CornerRadius="5" Margin="0,0,0,10" Padding="10">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="3*"/>
                                    <ColumnDefinition Width="2*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>

                                <StackPanel>
                                    <TextBlock Text="{Binding Name}" Foreground="White" FontSize="16" FontWeight="Bold"/>
                                    <TextBlock Text="{Binding IdDisplay}" Foreground="#CCC" FontSize="12"/>
                                </StackPanel>

                                <StackPanel Grid.Column="1">
                                    <TextBlock Text="{Binding Status}" Foreground="{Binding StatusColor}" FontSize="13"/>
                                    <TextBlock Text="{Binding DriveDisplay}" Foreground="#DDD" FontSize="12"/>
                                </StackPanel>

                                <Button Grid.Column="2"
                                        Content="Éjecter"
                                        Padding="10,5"
                                        Margin="10,0,0,0"
                                        Tag="{Binding DriveLetter}"
                                        Background="#AA3333"
                                        Foreground="White"
                                        IsEnabled="{Binding CanEject}"/>
                            </Grid>
                        </Border>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </ScrollViewer>

        <TextBlock Grid.Row="2"
                   Name="FooterText"
                   Foreground="#888"
                   FontSize="11"
                   HorizontalAlignment="Right"
                   Margin="0,5,0,0"/>
    </Grid>
</Window>
"@

    # Charger le XAML
    $xmlReader = New-Object System.Xml.XmlNodeReader ([xml]$XAML)
    $Window = [Windows.Markup.XamlReader]::Load($xmlReader)

    $UsbList = $Window.FindName("UsbList")
    $Footer = $Window.FindName("FooterText")

    # Binder les données
    $UsbList.ItemsSource = $Items
    $connectedCount = ($Items | Where-Object { $_.CanEject }).Count
    $totalCount = $Items.Count
    $Footer.Text = "$connectedCount / $totalCount clés détectées"

    # Gestion clic bouton "Éjecter"
    $UsbList.AddHandler(
        [System.Windows.Controls.Button]::ClickEvent,
        [System.Windows.RoutedEventHandler] {
            param($sender, $e)
            $btn = [System.Windows.Controls.Button]$e.OriginalSource
            $letter = $btn.Tag
            if ($letter) {
                Invoke-UsbEject -DriveLetter $letter
            }
        }
    )

    # Affichage
    $Window.ShowDialog() | Out-Null
}

function Invoke-UsbEject {
    param([string]$DriveLetter)

    if (-not $DriveLetter) { return }

    $drive = "$($DriveLetter):\"
    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace(17)

    foreach ($item in $folder.Items()) {
        if ($item.Path -eq $drive) {
            $item.InvokeVerb("Eject")
            [System.Windows.MessageBox]::Show("Clé USB $DriveLetter éjectée.", "USB", "OK", "Information")
            return
        }
    }

    [System.Windows.MessageBox]::Show("Impossible de trouver $drive dans le Shell.", "Erreur", "OK", "Error")
}

Export-ModuleMember -Function Show-UsbWindow, Invoke-UsbEject
