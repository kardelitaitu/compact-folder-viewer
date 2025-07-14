

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Folder and config paths
$folderPath = "C:\Users\Dika\Desktop\Brave Profiles\BAT"
$maxRows = 20
$configPath = Join-Path $PSScriptRoot 'FolderViewer.cfg'

# Load/save config
function Load-Config {
    if (Test-Path $configPath) {
        try { Get-Content $configPath | ConvertFrom-Json }
        catch { return @{ Width = 150; Height = 800; Left = 100; Top = 100 } }
    } else {
        return @{ Width = 150; Height = 800; Left = 100; Top = 100 }
    }
}
function Save-Config {
    param ($window)
    $config = @{
        Width = [int]$window.Width
        Height = [int]$window.Height
        Left = [int]$window.Left
        Top = [int]$window.Top
    }
    $config | ConvertTo-Json | Set-Content $configPath
}

# Load config
$config = Load-Config
$window = New-Object Windows.Window
$window.Title = "( o.o )"
$window.Width = $config.Width
$window.Height = $config.Height
$window.Left = $config.Left
$window.Top = $config.Top
$window.Background = "Black"
$window.Topmost = $true
$window.WindowStartupLocation = 'Manual'
$window.Add_Closed({ Save-Config $window })

# 💡 Hide minimize and maximize buttons, but allow resizing
$window.ResizeMode = 'CanResize'             # ✅ Allows drag resizing
$window.WindowStyle = 'ToolWindow'           # ✅ Removes minimize/maximize buttons


# Create ListBox with hidden scrollbar template
$styleXaml = @"
<Style xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
       TargetType="ListBox">
  <Setter Property="Template">
    <Setter.Value>
      <ControlTemplate TargetType="ListBox">
        <Border BorderThickness="{TemplateBinding BorderThickness}"
                BorderBrush="{TemplateBinding BorderBrush}"
                Background="{TemplateBinding Background}">
          <ScrollViewer Padding="{TemplateBinding Padding}"
                        VerticalScrollBarVisibility="Hidden"
                        HorizontalScrollBarVisibility="Disabled"
                        CanContentScroll="True">
            <ItemsPresenter/>
          </ScrollViewer>
        </Border>
      </ControlTemplate>
    </Setter.Value>
  </Setter>
</Style>
"@
$reader = New-Object System.Xml.XmlNodeReader([xml]$styleXaml)
$listBoxStyle = [Windows.Markup.XamlReader]::Load($reader)

# ListBox setup
$listBox = New-Object Windows.Controls.ListBox
$listBox.Style = $listBoxStyle
$listBox.SelectionMode = "Single"
$listBox.FontSize = 13
$listBox.BorderThickness = 0
$listBox.Background = "Transparent"
$listBox.HorizontalContentAlignment = "Left"
$listBox.VerticalContentAlignment = "Top"

# Load items
if (Test-Path $folderPath) {
    $files = Get-ChildItem -Path $folderPath
    for ($i = 0; $i -lt $files.Count; $i += $maxRows) {
        $group = $files[$i..([Math]::Min($i + $maxRows - 1, $files.Count - 1))]
        foreach ($file in $group) {
            $item = New-Object Windows.Controls.ListBoxItem
            # $item.Foreground = "#FA000000"  # 70% opacity black
            $item.Foreground = "LightGray"
            $item.Content = $file.BaseName
            $item.FontWeight = "SemiBold"
            $item.Tag     = $file.FullName
            $item.Padding = "4"
            $item.Margin  = "1"
            $item.Cursor  = "Hand"
            $listBox.Items.Add($item)
        }
    }
} else {
    $errorItem = New-Object Windows.Controls.ListBoxItem
    $errorItem.Content = "Folder not found: $folderPath"
    $listBox.Items.Add($errorItem)
}

# File launch events
$listBox.Add_MouseDoubleClick({
    if ($listBox.SelectedItem -and $listBox.SelectedItem.Tag) {
        Start-Process -FilePath $listBox.SelectedItem.Tag
    }
})
$listBox.Add_KeyDown({
    if ($_.Key -eq "Enter" -and $listBox.SelectedItem -and $listBox.SelectedItem.Tag) {
        Start-Process -FilePath $listBox.SelectedItem.Tag
    }
})

# Show window
$window.Content = $listBox
$window.ShowDialog()