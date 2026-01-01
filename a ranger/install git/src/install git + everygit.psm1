function Clone-Repo {
    Clear-Host

    #======================================================================
    # Git Installation Check
    #======================================================================
    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║            Git Installation          ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    try {
        $gitCmd = Get-Command git -ErrorAction SilentlyContinue

        if (-not $gitCmd) {
            Write-Host "➜  Git is not installed." -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Do you want to install Git now ? (Y/N)"
            Write-Host ""

            if ($choice -in @("Y", "y")) {
                Write-Host "Installing Git..." -ForegroundColor Yellow
                winget install --id Git.Git -e --source winget

                # Reload PATH
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")

                Write-Host ""
                Write-Host "✔  Git has been installed successfully." -ForegroundColor Green
                Write-Host ""
            }
            else {
                Write-Host "⚠  Git installation skipped. The script cannot continue." -ForegroundColor DarkRed
                Pause
                return
            }
        }
    }
    catch {
        Write-Host "Error while checking Git installation." -ForegroundColor Red
        return
    }

    Clear-Host

    #======================================================================
    # Clone GitHub Repositories
    #======================================================================

    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║               WKT Clone              ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    $clonePath = "C:\Repos"
    if (-not (Test-Path $clonePath)) {
        New-Item -ItemType Directory -Path $clonePath | Out-Null
    }

    $user = Read-Host "Enter the GitHub username to clone repos from"
    Write-Host ""

    # Correct GitHub API URL
    $repos = Invoke-RestMethod "https://api.github.com/users/$user/repos"

    # Affichage des repos avec numéros
    Write-Host "Available repositories:" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $repos.Count; $i++) {
        Write-Host "[$($i+1)] $($repos[$i].name)" -ForegroundColor Yellow
        Write-Host ""
    }

    #======================================================================
    # Clone All GitHub Repositories
    #======================================================================

    function Clone-All {
        foreach ($repo in $repos) {

            $target = "$clonePath\$($repo.name)"

            if (Test-Path $target) {
                Write-Host "⚠  $($repo.name) already exists. Updating..." -ForegroundColor Yellow
                Set-Location $target
                git pull origin main
            }
            else {
                Write-Host "✔  Cloning $($repo.name)..." -ForegroundColor Green
                git clone $repo.clone_url $target
            }

            Write-Host ""
        }

        Pause
    }

    #======================================================================
    # Ask user for each repo OR clone all
    #======================================================================

    foreach ($repo in $repos) {

        $choice = Read-Host "Do you want to clone $($repo.name) ? (Y/N) or all repositories (A) ?"
        Write-Host ""

        if ($choice -in @("A", "a")) {
            Clone-All
            break   # ⬅️ IMPORTANT : on sort de la boucle principale
        }

        if ($choice -in @("Y", "y")) {

            $target = "$clonePath\$($repo.name)"

            if (Test-Path $target) {
                Write-Host "⚠  Folder already exists. Updating..." -ForegroundColor Yellow
                Set-Location $target
                git pull origin main
            }
            else {
                Write-Host "✔  Cloning $($repo.name)..." -ForegroundColor Green
                git clone $repo.clone_url $target
            }
        }
        else {
            Write-Host "Skipping $($repo.name)..."
        }

        Write-Host ""
        Pause
        Write-Host ""
    }

}

Export-ModuleMember -Function Clone-Repo
