
[Enum]::GetValues([System.ConsoleColor]) | ForEach-Object {
    Write-Host $_ -ForegroundColor $_
}
Write-Host ""