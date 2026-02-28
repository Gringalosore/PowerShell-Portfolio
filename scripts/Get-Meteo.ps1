param(
    [string]$Ville = "Saint-Pierre",
    [string]$CodePays = "RE",
    [string]$ExportCSV
)

# Vérification clé API
$ApiKey = $env:OPENWEATHER_API_KEY
if (-not $ApiKey) {
    Write-Error "Variable d'environnement OPENWEATHER_API_KEY non définie."
    exit 1
}

$Url = "https://api.openweathermap.org/data/2.5/weather?q=$Ville,$CodePays&appid=$ApiKey&units=metric&lang=fr"

try {
    $Response = Invoke-RestMethod -Uri $Url -Method Get -ErrorAction Stop
}
catch {
    Write-Host "❌ Erreur lors de l'appel API"

    if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Host "Ville introuvable."
    }
    elseif ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Clé API invalide."
    }
    else {
        Write-Host "Problème réseau ou serveur."
    }
    exit 1
}

# Extraction données
$Temp = $Response.main.temp
$Ressenti = $Response.main.feels_like
$Description = (Get-Culture).TextInfo.ToTitleCase($Response.weather[0].description)
$Humidite = $Response.main.humidity
$Pression = $Response.main.pressure
$Date = Get-Date -Format "dd/MM/yyyy à HH:mm"

# Emoji météo
$Emoji = "🌤️"
if ($Description -match "ciel dégagé") { $Emoji = "☀️" }
elseif ($Description -match "nuage") { $Emoji = "☁️" }
elseif ($Description -match "pluie") { $Emoji = "🌧️" }

# Affichage formaté
Write-Host "═══════════════════════════════════"
Write-Host "$Emoji Météo à $Ville"
Write-Host "═══════════════════════════════════"
Write-Host "📅 Date : $Date"
Write-Host "🌡️ Température : $Temp°C (ressenti $Ressenti°C)"
Write-Host "☁️ Conditions : $Description"
Write-Host "💧 Humidité : $Humidite%"
Write-Host "🔽 Pression : $Pression hPa"
Write-Host "═══════════════════════════════════"

# Export CSV (Bonus)
if ($ExportCSV) {

    $Objet = [PSCustomObject]@{
        Date        = Get-Date
        Ville       = $Ville
        Temperature = $Temp
        Conditions  = $Description
    }

    if (Test-Path $ExportCSV) {
        $Objet | Export-Csv -Path $ExportCSV -Append -NoTypeInformation
    }
    else {
        $Objet | Export-Csv -Path $ExportCSV -NoTypeInformation
    }

    Write-Host "📁 Historique exporté vers $ExportCSV"
}