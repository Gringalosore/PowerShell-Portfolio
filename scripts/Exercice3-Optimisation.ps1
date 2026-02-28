<#
Exercice 3 - Optimisation requêtes API GitHub

Différence :
Ancien script = 100 requêtes individuelles (1 par utilisateur)
Nouveau script = 1 requête groupée via Search API

Gain :
- Moins d'appels réseau
- Moins de risque de rate limit
- Exécution beaucoup plus rapide
#>

$token = $env:GITHUB_TOKEN

if (-not $token) {
    Write-Host "Token GitHub manquant !" -ForegroundColor Red
    exit
}

$headers = @{
    Authorization = "token $token"
    Accept        = "application/vnd.github.v3+json"
}

# Construction requête groupée
$query = (1..100 | ForEach-Object { "user$_" }) -join "+OR+"
$uri = "https://api.github.com/search/users?q=$query&per_page=100"

$executionTime = Measure-Command {
    try {
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
        $users = $response.items
    }
    catch {
        Write-Host "Erreur API GitHub" -ForegroundColor Red
        return
    }
}

Write-Host "$($users.Count) utilisateurs récupérés en $($executionTime.TotalSeconds) secondes"