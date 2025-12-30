Clear-Host
# Chemin du fichier contenant les emails

$filePath = ".\Library\fileforgmail.psm1"

# Vérifier si le fichier existe
if (-not (Test-Path $filePath)) {
    Write-Host "❌ File not found: $filePath" -ForegroundColor Red
    return
}

# Lire les emails
$emails = Get-Content $filePath |
Where-Object { $_.Trim() -notmatch "^#" -and $_.Trim() -ne "" }


# Vérifier qu'il y a au moins un email
if ($emails.Count -eq 0) {
    Write-Host "❌ The file is empty." -ForegroundColor Red
    return
}

# Ouvrir une page Gmail pour chaque email
foreach ($email in $emails) {

    # Nettoyage (au cas où il y a des espaces)
    $email = $email.Trim()

    if ($email -eq "") { continue }

    $url = "https://accounts.google.com/AccountChooser?Email=$email"

    Write-Host ""
    Write-Host "Opening Gmail login for: $email" -ForegroundColor Cyan
    Write-Host ""
    Start-Process $url
}
Pause
Clear-Host
