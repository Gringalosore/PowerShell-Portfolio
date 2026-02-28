# PowerShell-Portfolio
Scripts PowerShell - TP R405 BUT R&amp;T IUT Réunion
================================================================================
                        TP2 — PowerShell & Consommation d'API

Nom    : SORRES
Prénom : Alexy
Date   : 28/02/2026


RÉSUMÉ DES FONCTIONNALITÉS IMPLÉMENTÉES
================================================================================

Exercice 1 — Débogage (Get-Meteo.ps1)
--------------------------------------
Script de météo interrogeant l'API OpenWeatherMap.
Fonctionnalités :
  - Récupération de la météo pour une ville donnée (défaut : Saint-Pierre, RE)
  - Paramètres optionnels : -Ville et -CodePays
  - Export de l'historique en CSV via le paramètre -ExportCSV
  - Affichage formaté avec emojis et séparateurs
  - Clé API chargée depuis une variable d'environnement (OPENWEATHER_API_KEY)

Les 5 erreurs corrigées :
  1. Content-Type incorrect (XML → JSON)
  2. Mauvaise méthode HTTP (POST → GET)
  3. Paramètres passés dans -Body au lieu de l'URL
  4. Mauvais calcul de température (conversion Kelvin inutile, units=metric suffit)
  5. Mauvais accès à weather.description (tableau → weather[0].description)
  + Bonus : suppression de l'affichage de la clé API en clair dans la console

Exercice 2 — Reverse Engineering (Exercice2-ReverseEngineering.ps1)
--------------------------------------------------------------------
Script interrogeant l'API publique de l'ISS (open-notify.org).
Fonctionnalités :
  - Récupération de la position en temps réel (latitude, longitude, timestamp)
  - Calcul et affichage de la vitesse orbitale approximative (27 600 km/h)
  - Affichage formaté

Exercice 3 — Script avancé Get-Meteo.ps1 (fonctionnalités étendues)
---------------------------------------------------------------------
  - Support multi-ville via paramètres -Ville / -CodePays
  - Choix des emojis météo selon les conditions (pluie, soleil, nuages…)
  - Accumulation des relevés dans un fichier CSV historique (-ExportCSV)
  - Boucle de test : 5 relevés successifs toutes les 2 secondes

Exercice 4 — Sécurité (Exercice4-Securite-Corrige.ps1)
-------------------------------------------------------
Analyse et correction d'un script GitHub API vulnérable.
3 vulnérabilités identifiées et corrigées :
  1. Token GitHub codé en dur dans le script → chargement via variable
     d'environnement (GITHUB_TOKEN)
  2. Injection possible via le paramètre Username (absence de validation)
     → validation par regex [a-zA-Z0-9_-]{1,39}
  3. Affichage du token dans les logs (Write-Host) → suppression totale
Fonctionnalités du script corrigé :
  - Récupération et affichage des repositories d'un utilisateur GitHub
  - Détection des repositories inactifs (> 180 jours sans push)
  - Statistiques : total, actifs, inactifs avec pourcentages

DIFFICULTÉS RENCONTRÉES
================================================================================

- Exercice 1 : Identifier que weather est un tableau JSON et qu'il faut
  impérativement accéder à l'index [0] pour obtenir la description.
  L'erreur était silencieuse (pas d'exception, juste une valeur vide).

- Exercice 3 : Gérer le mode d'ajout au CSV sans écraser les lignes
  existantes (utilisation de Export-Csv avec -Append et -NoTypeInformation).

- Exercice 4 : Comprendre que même en PowerShell, une concaténation directe
  d'un paramètre utilisateur dans une URL constitue un vecteur d'injection,
  et que la validation par regex est la bonne pratique.

- Général : Stocker et recharger les variables d'environnement dans la même
  session PowerShell (nécessité d'utiliser SetEnvironmentVariable + affectation
  immédiate de $env:).

TEMPS PASSÉ PAR EXERCICE
================================================================================

  Exercice 1 — Débogage           : ~30 minutes
  Exercice 2 — Reverse Engineering : ~20 minutes
  Exercice 3 — Script avancé      : ~45 minutes
  Exercice 4 — Sécurité           : ~25 minutes
  README + packaging               : ~10 minutes
  ─────────────────────────────────────────────
  Total                            : ~2h10

