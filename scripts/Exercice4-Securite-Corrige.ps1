<#
Exercice 4 - Script sécurisé

Corrections :
1. Suppression du token en clair → utilisation variable d’environnement
2. Validation stricte du Username
3. Suppression affichage du token
4. Ajout gestion d’erreurs
#>

param(
    [Parameter(Mandatory)]
    [ValidatePattern("^[a-zA-Z0-9-]+$")]
    [string]$Username
)

# Utilisation variable d’environnement
$token = $env:GITHUB_TOKEN

if (-not $token) {
    Write-Host "Token GitHub manquant !" -ForegroundColor Red
    exit
}

$uri = "https://api.github.com/users/$Username/repos"

$headers = @{
    Authorization = "token $token"
    Accept        = "application/vnd.github.v3+json"
}

try {
    $repos = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
    $repos | Format-Table name, language -AutoSize
}
catch {
    Write-Host "Erreur lors de la récupération des repos." -ForegroundColor Red
    Write-Host $_.Exception.Message
}