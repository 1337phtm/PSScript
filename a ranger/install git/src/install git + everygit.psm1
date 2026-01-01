
function clone-repo {

    #======================================================================
    # Install Git
    #======================================================================
    function Get-GitInstallation {
        Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║            Git Installation          ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""

        # Vérification de l'installation de Git
        try {
            $gitCmd = Get-Command git -ErrorAction SilentlyContinue

            if ($gitCmd) {
                continue
            }
            else {
                Write-Host "➜  Git n'est pas installé." -ForegroundColor Yellow
                Write-Host ""
                $choice = Read-Host "Do you want to install Git now ? (Y/N)"
                Write-Host ""
                if ($choice -eq "Y" -or $choice -eq "y") {
                    Write-Host "Installing Git..." -ForegroundColor Yellow
                    winget install --id Git.Git -e --source winget

                    # Recharge PATH pour que Git soit reconnu immédiatement
                    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("Path", "User")

                    Write-Host "✔  Git has been installed successfully." -ForegroundColor Green
                    Write-Host ""
                }
                else {
                    Write-Host "⚠  Git installation skipped. The script cannot continue." -ForegroundColor DarkRed
                    Write-Host ""
                    return
                }
            }
        }
        catch {
            Write-Host "Erreur lors de la vérification de Git."
        }

        Write-Host ""
        Pause
        Clear-Host
    }

    #======================================================================
    # Installation WKT
    #======================================================================

    function Get-WKTInstallation {
        Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║               WKT clone              ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""

        $clonePath = "C:\Repos"
        $user = Read-Host "Enter the GitHub username to clone repos from"

        # Récupère tous les repos publics de l'utilisateur
        $repos = Invoke-RestMethod "https://api.github.com/users/$user/repositoryGithub"

        foreach ($repo in $repos) {
            Write-Host ""
            $Choice = Read-Host "Do you want to clone the repository : $($repo.name) ? (Y/N)"
            Write-Host ""
            if ($Choice -eq 'Y' -or $Choice -eq 'y') {
                Write-Host "✔  Proceeding to clone $($repo.name)." -ForegroundColor Green
                Write-Host ""
                $url = $repo.clone_url
                git clone $url $clonePath\$($repo.name)
            }
            else {
                Write-Host "Skipping $($repo.name)..."
                Write-Host ""
                continue
            }
            Write-Host ""
            Pause
            Write-Host ""
        }

    }

    Clear-Host
    Get-GitInstallation
    Get-WKTInstallation
    Clear-Host

}

Export-ModuleMember -Function *-*
