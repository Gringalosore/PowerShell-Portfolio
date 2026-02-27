## Pagination GitHub

- **Pourquoi nécessaire ?**
La pagination a pour but de garantir que les réponses API sont plus faciles à gérer, permet de retourner plus de reposite en une seule requête car elle est limite.

- **Comment fonctionne ?**  
On envoie plusieurs requêtes successives en augmentant le paramètre `page` tant qu’on reçoit des résultats. La boucle continue jusqu’à ce que la page retournée ait moins que `per_page` éléments.

- **Paramètres utilisés :**  
  - `per_page=100` → nombre maximum de repos par requête  
  - `page=1,2,3,...` → numéro de la page à récupérer 
