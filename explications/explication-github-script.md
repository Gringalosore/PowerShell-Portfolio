## Pagination GitHub

- **Pourquoi nécessaire ?**
La pagination a pour but de garantir que les réponses API sont plus faciles à gérer, permet de retourner plus de reposite en une seule requête car elle est limite.

- **Comment fonctionne ?**  
On envoie plusieurs requêtes successives en augmentant le paramètre `page` tant qu’on reçoit des résultats. La boucle continue jusqu’à ce que la page retournée ait moins que `per_page` éléments.

- **Paramètres utilisés :**  
  - `per_page=100` → nombre maximum de repos par requête  
  - `page=1,2,3,...` → numéro de la page à récupérer 
---

## `updated_at` vs `pushed_at`
- Le champ `pushed_at` est mis à jour à chaque fois qu'un commit est poussé vers l'une des branches du dépôt.
- Le champ `updated_at` est mis à jour à chaque modification de l'objet dépôt, par exemple lors de la mise à jour de la description ou de la langue principale du dépôt.
- **Pourquoi pushed_at ?**  
  Pour mesurer l’activité réelle du projet. Un repo peut avoir un `updated_at` récent mais aucun code ajouté depuis des mois.  

## Schéma du flux

```Schema
┌─────────────────────┐
│ Récupération repos  │
│  - Boucle pagination│
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Calcul inactivité   │
│  - pushed_at → jours│
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Filtrage repos      │
│  - > seuil jours    │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Affichage tableau   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Export CSV (option) │
└─────────────────────┘
```
---
## Documentez votre démarche :

- Quelles difficultés techniques avez-vous rencontrées ?
  J'ai eu quelque problem lors de la configuration des Token dans l'environnement

-  Comment les avez-vous résolues (recherches, tests, essais-erreurs) ?
  j'ai fait des recherche, demander de l'aide a mais camarade et essai les solution donner sans avoir le retour d'information que la clé soit stockée
-  Qu'avez-vous appris de cette expérience ?
  Que mon powershell n'affiche pas le Token stocker dans l'environnement mais que les code marche

---
