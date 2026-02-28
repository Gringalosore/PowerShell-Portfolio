<#
Script corrigé - Exercice 1 Débogage API
Auteur : SORRES Alexy
Date : 28/02/26
#>

param(
    [string]$Ville = "Saint-Pierre"
)

# Récupération clé API
$apiKey = $env:OPENWEATHER_API_KEY

if (-not $apiKey) {
    Write-Host "Clé API manquante !" -ForegroundColor Red
    exit
}

# Construction URL (méthode GET)
$url = "https://api.openweathermap.org/data/2.5/weather?q=$Ville&appid=$apiKey&units=metric"

try {
    $response = Invoke-RestMethod -Uri $url -Method Get

    # Extraction correcte des données
    $temperature = $response.main.temp
    $conditions  = $response.weather[0].description
    $humidity    = $response.main.humidity

    Write-Host "═══════════════════════════════"
    Write-Host "🌤️ Météo à $Ville"
    Write-Host "═══════════════════════════════"
    Write-Host "🌡️ Température : $temperature°C"
    Write-Host "☁️ Conditions : $conditions"
    Write-Host "💧 Humidité : $humidity%"
}
catch {
    Write-Host "Erreur lors de l'appel API :" -ForegroundColor Red
    Write-Host $_.Exception.Message
}