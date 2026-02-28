<#
Exercice 2 - Reverse Engineering API ISS
Auteur : SORRES Alexy
Date : 28/02/26

Démarche :
À partir des indices (API publique, open-notify, JSON, ISS),
j’ai recherché les endpoints disponibles.
L’endpoint iss-now.json retourne latitude, longitude et timestamp.
La vitesse n’étant pas fournie par l’API, elle est ajoutée comme
valeur approximative (vitesse moyenne réelle de l’ISS ≈ 27 600 km/h).
#>

$uri = "http://api.open-notify.org/iss-now.json"

try {
    $response = Invoke-RestMethod -Uri $uri -Method Get

    $latitude  = $response.iss_position.latitude
    $longitude = $response.iss_position.longitude
    $timestamp = $response.timestamp

    # Vitesse moyenne approximative de l’ISS
    $vitesse = 27600

    Write-Host "═══════════════════════════════════"
    Write-Host "📍 Position actuelle de l'ISS"
    Write-Host "═══════════════════════════════════"
    Write-Host "Latitude : $latitude"
    Write-Host "Longitude : $longitude"
    Write-Host "Timestamp : $timestamp"
    Write-Host "Vitesse : $vitesse km/h (approximative)"
    Write-Host "═══════════════════════════════════"
}
catch {
    Write-Host "Erreur lors de l'appel API." -ForegroundColor Red
    Write-Host $_.Exception.Message
}