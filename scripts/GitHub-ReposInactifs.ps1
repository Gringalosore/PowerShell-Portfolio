<#
.SYNOPSIS
 Liste les repositories GitHub inactifs depuis plus de 6 mois

.DESCRIPTION
 Ce script interroge l'API GitHub pour récupérer tous vos repositories et identifier
 ceux qui n'ont pas été mis à jour (push) depuis plus de 6 mois.
 Les résultats sont affichés dans un tableau formaté et peuvent être exportés en CSV.

.PARAMETER Token
 Personal Access Token GitHub avec le scope 'repo'
 Obligatoire. Peut être fourni via la variable d'environnement $env:GITHUB_TOKEN

.PARAMETER Jours
 Nombre de jours d'inactivité pour considérer un repo comme inactif (défaut : 180)

.PARAMETER ExportCsv
 Chemin optionnel pour exporter les résultats en CSV

.EXAMPLE
 .\GitHub-ReposInactifs.ps1 -Token $env:GITHUB_TOKEN
 Liste les repos inactifs depuis plus de 6 mois

.EXAMPLE
 .\GitHub-ReposInactifs.ps1 -Token $env:GITHUB_TOKEN -Jours 90
 Liste les repos inactifs depuis plus de 3 mois

.EXAMPLE
 .\GitHub-ReposInactifs.ps1 -Token $env:GITHUB_TOKEN -ExportCsv "repos-inactifs.csv"
 Exporte les résultats dans un fichier CSV

.NOTES
 Auteur : Alexy SORRES
 Date : 27/02/26
 Version : 1.0
 Prérequis : PowerShell 5.1+ ou PowerShell Core 7+
#>
[CmdletBinding()]
param(
 [Parameter(Mandatory=$true, HelpMessage="Personal Access Token GitHub")]
 [ValidateNotNullOrEmpty()]
 [string]$Token,

 [Parameter()]
 [ValidateRange(1, 3650)]
 [int]$Jours = 180,

 [Parameter()]
 [string]$ExportCsv
)
# =========================================
# ÉTAPE 1 : Configuration des en-têtes
# =========================================
$headers = @{
 Authorization = "token $Token"
 Accept = "application/vnd.github.v3+json"
}
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Red
Write-Host " 🔍 Analyse des repositories GitHub inactifs" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════" -ForegroundColor Red 
Write-Host ""
# =========================================
# ÉTAPE 2 : Récupération de tous les repos
# =========================================
Write-Host "📥 Récupération de vos repositories..." -ForegroundColor Yellow

$allRepos = @()
$page = 1
$perPage = 100

try {
    do {
        $url = "https://api.github.com/user/repos?per_page=$perPage&page=$page&sort=pushed&direction=desc"
        $repos = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorAction Stop

        if ($repos.Count -gt 0) {
            $allRepos += $repos
            $page++
        }

    } while ($repos.Count -eq $perPage)
}
catch {
    Write-Host "Erreur API GitHub"

    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Token invalide ou expiré." -ForegroundColor Red
    }
    elseif ($_.Exception.Response.StatusCode -eq 403) {
        Write-Host "Rate limit atteint." -ForegroundColor Red
    }
    else {
        Write-Host "Problème réseau ou API." -ForegroundColor Red
    }
    exit 1
}

Write-Host "$($allRepos.Count) repositories récupérés"
Write-Host ""
# TODO : Implémenter la pagination pour récupérer TOUS les repos
# Indice : Boucle do/while avec $page++ et vérification $repos.Count
# =========================================
# ÉTAPE 3 : Calcul de l'inactivité
# =========================================
$dateLimit = (Get-Date).AddDays(-$Jours)
$reposInactifs = @()

foreach ($repo in $allRepos) {

    $dernierPush = $repo.pushed_at
    $joursInactivite = ((Get-Date) - $dernierPush).Days

    if ($joursInactivite -gt $Jours) {

        $reposInactifs += [PSCustomObject]@{
            Nom             = $repo.name
            DernierPush     = $dernierPush.ToString("yyyy-MM-dd")
            JoursInactivite = $joursInactivite
            URL             = $repo.html_url
        }
    }
}

# Tri décroissant par inactivité (BONUS)
$reposInactifs = $reposInactifs | Sort-Object JoursInactivite -Descending

# =========================================
# ÉTAPE 4 : Affichage des résultats
# =========================================
if ($reposInactifs.Count -eq 0) {
    Write-Host "🟢 Aucun repository inactif trouvé !" -ForegroundColor Green
}
else {
    Write-Host "🔴 $($reposInactifs.Count) repository(s) inactif(s) depuis plus de $Jours jours :"
    Write-Host ""

    $reposInactifs | Format-Table -AutoSize
}

# =========================================
# ÉTAPE 5 : Statistiques (BONUS)
# =========================================
$total = $allRepos.Count
$inactifs = $reposInactifs.Count
$actifs = $total - $inactifs

if ($total -gt 0) {
    $pourcentage = [math]::Round(($inactifs / $total) * 100, 0)

    Write-Host ""
    Write-Host "📊 Statistiques :" -ForegroundColor Cyan
    Write-Host " Total : $total repositories"
    Write-Host " Actifs : $actifs ($([math]::Round((100-$pourcentage),0))%) 🟢"
    Write-Host " Inactifs : $inactifs ($pourcentage%) 🔴"
}
# =========================================
# ÉTAPE 6 : Export CSV (si demandé)
# =========================================
if ($ExportCsv -and $reposInactifs.Count -gt 0) {
    $reposInactifs | Export-Csv -Path $ExportCsv -NoTypeInformation -Encoding UTF8
    Write-Host ""
    Write-Host "✅ Résultats exportés dans : $ExportCsv"
}