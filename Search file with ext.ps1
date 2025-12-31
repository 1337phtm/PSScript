Clear-Host

# Demande l'extension
$ext = Read-Host "Enter the file extension to search (.kdbx, .txt, .jpg, etc.) "
$ext = $ext.TrimStart(".")   # Normalisation de l'extension

# Récupère tous les lecteurs
$drives = Get-PSDrive -PSProvider FileSystem

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        Select a drive to scan        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

#======================================================================
# Affichage des lecteurs disponibles
#======================================================================
for ($i = 0; $i -lt $drives.Count; $i++) {
    Write-Host "[$($i+1)] $($drives[$i].Name):  $($drives[$i].Root)" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "[A] All drives" -ForegroundColor Green
Write-Host ""
Write-Host "[0] Exit" -ForegroundColor Red
Write-Host ""

#======================================================================
# Choix de l'utilisateur
#======================================================================
$drivechoice = Read-Host "Enter your choice"

switch ($drivechoice.ToUpper()) {

    "0" {
        Clear-Host
        return
    }

    "A" {
        Write-Host ""
        Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║         Scanning ALL drives...       ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan

        foreach ($drive in $drives) {
            Write-Host ""
            Write-Host "Scanning $($drive.Root) ..." -ForegroundColor Yellow
            Write-Host ""
            Get-ChildItem -Path $drive.Root -Filter "*.$ext" -Recurse -ErrorAction SilentlyContinue
        }
        return
    }

    default {
        # Convertit le choix en index (1 → 0, 2 → 1, etc.)
        $index = [int]$drivechoice - 1

        if ($index -ge 0 -and $index -lt $drives.Count) {
            $selectedDrive = $drives[$index]

            Write-Host ""
            Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║ You selected drive: $($selectedDrive.Name)                ║" -ForegroundColor Cyan
            Write-Host "║ Path: $($selectedDrive.Root)                            ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host ""

            Write-Host "Searching for *.$ext in $($selectedDrive.Root) ..." -ForegroundColor Cyan
            Get-ChildItem -Path $selectedDrive.Root -Filter "*.$ext" -Recurse -ErrorAction SilentlyContinue
        }
        else {
            Write-Host "Invalid choice." -ForegroundColor Red
            return
        }
    }
}
