Import-Module "..\lib\usb-gui.psm1" -Force -DisableNameChecking

# Table des clés connues
$TargetSerial = @(
    @{ Serial = "057D09C52080"; Name = "Clé 1 - Sam le pirate" }
    @{ Serial = "4C530399900717110192"; Name = "Clé 2 - SANDISK" }
    @{ Serial = "03018826012622135933"; Name = "Clé 3 - SANDISK" }
    @{ Label = "CLE4"; Name = "Clé 4 - Verte" }
    @{ Label = "CLE5"; Name = "Clé 5 - Jaune" }
    @{ Label = "CLE6"; Name = "Clé 6 - Orange" }
    @{ Label = "CLE8"; Name = "Clé 8 - Rose" }
    @{ Label = "CLEX"; Name = "" }
    @{ Label = "CLE9"; Name = "Clé 9 - Violet" }
    @{ Label = "CLE10"; Name = "Clé 10 - Noir" }
    @{ Label = "CLE11"; Name = "Clé 11 - Grise" }
    @{ Label = "CLE12" ; Name = "Clé 12 - Blanche" }
    @{ Serial = "AA00000000000489"; Name = "Clé 13 - Tesla" }
    @{ Serial = "372710504A479E6304869"; Name = "Clé 14 - Dark Vador" }
    @{ Serial = "372701377C24885516272"; Name = "Clé 15 - Grogu" }
    @{ Serial = "00015016041925164552"; Name = "Clé 16 - Save" }
    @{ Serial = "00014715041925162437"; Name = "Clé 17 - VENTOY" }
    @{ Serial = "A4ORA52700225B"; Name = "PADLOCK - CORSAIR" }
)



# Snapshot des disques/volumes
$usbDisks = Get-Disk   | Where-Object { $_.BusType -eq 'USB' }
$usbVols = Get-Volume | Where-Object { $_.DriveType -eq 'Removable' }

$items = foreach ($entry in $TargetSerial) {
    $sn = $entry.Serial
    $label = $entry.Label
    $name = $entry.Name

    $device = $null
    $driveLetter = $null

    if ($sn) {
        $device = $usbDisks | Where-Object { $_.SerialNumber -eq $sn }
    }
    if (-not $device -and $label) {
        $vol = $usbVols | Where-Object { $_.FileSystemLabel -eq $label }
        if ($vol) {
            $part = Get-Partition | Where-Object { $_.DriveLetter -eq $vol.DriveLetter }
            if ($part) {
                $device = $usbDisks | Where-Object { $_.Number -eq $part.DiskNumber }
            }
        }
    }

    if ($device) {
        $part = Get-Partition | Where-Object { $_.DiskNumber -eq $device.Number }
        $vol = $usbVols | Where-Object { $_.DriveLetter -eq $part.DriveLetter }
        $driveLetter = $vol.DriveLetter

        [PSCustomObject]@{
            Name         = if ($name) { $name } else { "Clé USB inconnue" }
            Serial       = $device.SerialNumber
            Label        = $vol.FileSystemLabel
            IdDisplay    = if ($sn) { "Serial : $sn" } elseif ($label) { "Label : $label" } else { "" }
            DriveLetter  = $driveLetter
            DriveDisplay = "Lettre : $driveLetter`:"
            Status       = "Connectée"
            StatusColor  = "LightGreen"
            CanEject     = $true
        }
    }
    else {
        [PSCustomObject]@{
            Name         = if ($name) { $name } else { "Clé USB inconnue" }
            Serial       = $sn
            Label        = $label
            IdDisplay    = if ($sn) { "Serial : $sn" } elseif ($label) { "Label : $label" } else { "" }
            DriveLetter  = $null
            DriveDisplay = "Non montée"
            Status       = "Non détectée"
            StatusColor  = "OrangeRed"
            CanEject     = $false
        }
    }
}

# Appel de la fenêtre WPF avec les données
Show-UsbWindow -Items $items
