$Global:ErrorActionPreference = "Stop"

#======================================================================
# Importation des modules
#======================================================================
Import-Module "$PSScriptRoot\src\Install git.psm1" -Force -DisableNameChecking
Import-Module "$PSScriptRoot\src\install git + everygit.psm1" -Force -DisableNameChecking
#Import-Module "$PSScriptRoot\src\install git + WKT.psm1" -Force -DisableNameChecking

#======================================================================
# Affichage du menu principal
#======================================================================
function Show-Main {
    Clear-Host
    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║            GITHUB TOOLKIT            ║" -ForegroundColor Green
    Write-Host "║          WRITTEN BY 1337phtm         ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "[1]  Install git" -ForegroundColor DarkCyan
    Write-Host "[2]  Clone repo from user" -ForegroundColor DarkYellow
    Write-Host "[3]  Update repo" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "[0]  Exit" -ForegroundColor DarkGray
    Write-Host ""
}


#======================================================================
# Fonction du menu principal
#======================================================================
function Start-Main {
    do {
        Show-Main
        $choice = Read-Host "Choose an option"
        switch ($choice) {
            "1" { Install-Git }
            "2" { clone-repo }
            "3" {  }
            "0" {
                Clear-Host
                return
            }
            default {
                Write-Host "Invalid choice." -ForegroundColor Red
                Pause
            }
        }
    } until ($choice -eq "0")
}

Start-Main
