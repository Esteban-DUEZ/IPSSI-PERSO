# Monitoring Stack avec Docker, Nginx, Grafana, Prometheus et API Flask

## Présentation
Ce projet met en place une stack de monitoring complète avec les outils suivants :
- **Grafana** : visualisation des métriques
- **Prometheus** : collecte des métriques
- **Node Exporter** et **Postgres Exporter** : export des métriques système et base de données
- **API Flask** : backend simple pour démonstration
- **PostgreSQL** : base de données pour l’API
- **nginx** : reverse proxy pour exposer tous les services

## Architecture
```
+-------------------+
|     nginx         |
|-------------------|
| /grafana/  ---> grafana:3000
| /prometheus/ ---> prometheus:9090
| /api/       ---> backend:5000
+-------------------+
```
- Tous les services sont orchestrés via **Docker Compose**.
- Les réseaux `frontend` et `backend` isolent les services.
- Les variables d’environnement sont centralisées dans le fichier `.env`.

## Configuration nginx
Le fichier `nginx.conf` configure le reverse proxy :
- `/grafana/` → Grafana
- `/prometheus/` → Prometheus
- `/api/` → API Flask

## Endpoints API Flask
- `GET /api/health` : Vérifie la santé de l’API
- `GET /api/tasks` : Liste les tâches
- `POST /api/tasks` : Ajoute une tâche
- `GET /api/` : Message d’accueil API

## Exemples de réponses API Flask

- `GET /api/health` :
```json
{"status": "healthy"}
```

- `GET /api/` :
```json
{"message": "API root OK"}
```

- `GET /api/tasks` :
```json
[]
```

## Accès aux services
- **Grafana** : http://localhost/grafana/
- **Prometheus** : http://localhost/prometheus/
- **API Flask** : http://localhost/api/

## Variables d’environnement
Exemple de fichier `.env` :
```
POSTGRES_DB=todo
POSTGRES_USER=todo_user
POSTGRES_PASSWORD=SuperSecretPassword123!
GRAFANA_USER=admin
GRAFANA_PASSWORD=UltraSecureGrafanaPwd!
```

## Sécurité
- Changez les mots de passe par défaut avant mise en production.
- Limitez l’accès public via firewall ou configuration réseau.

## Démarrage rapide
```bash
docker-compose build
docker-compose up -d
```

## Tests
- Vérifiez l’accès aux dashboards Grafana et Prometheus via nginx.
- Testez l’API Flask :
  - `curl http://localhost/api/health`
  - `curl http://localhost/api/`

## Tests automatiques de la stack

Pour vérifier que tous les services sont accessibles via nginx, lancez les commandes suivantes :

```bash
# Test Grafana
curl -s http://localhost/grafana/ | head -n 20
# Test Prometheus
curl -s http://localhost/prometheus/ | head -n 20
# Test API Flask
curl -s http://localhost/api/health
```

Exemples de résultats attendus :
- Grafana : redirection vers la page de login (`<a href="/grafana/login">Found</a>`) 
- Prometheus : redirection vers la page de requête (`<a href="/query">Found</a>`) 
- API Flask : `{"status":"healthy"}`

Si tous les retours sont conformes, la stack est opérationnelle et prête pour le rendu.

## Pourquoi nginx ?
- Choix pour la simplicité, la documentation et la flexibilité.
- Remplace Traefik pour ce projet car la config est plus directe et adaptée à un rendu pédagogique.

## Screenshots / Démo
Ajoutez ici des captures d’écran ou exemples de requêtes pour le rendu.

## Bonnes pratiques pour l'URL Grafana

> ⚠️ Pour éviter de versionner l'IP du serveur, utilisez une variable d'environnement dynamique. Exemple :

Dans `.env` (ne pas versionner la valeur réelle, juste la clé) :
```
GF_SERVER_ROOT_URL=http://$(hostname -I | awk '{print $1}')/grafana/
```
Dans `docker-compose.yml` :
```
- GF_SERVER_ROOT_URL=${GF_SERVER_ROOT_URL}
```

Ou, pour une solution plus portable, laissez la variable vide dans `.env` et définissez-la à l'exécution :
```
GF_SERVER_ROOT_URL=
```
Et lancez :
```
GF_SERVER_ROOT_URL="http://$(hostname -I | awk '{print $1}')/grafana/" docker-compose up -d
```

## Schéma réseau (ASCII)

```
           +-------------------+
           |      nginx        |
           +-------------------+
           |   /grafana/       |
           |   /prometheus/    |
           |   /api/           |
           +-------------------+
                    |
        +-----------+---------------------+
        |           |                     |
+--------+   +-------------+      +-------------+
| Grafana|<-->| Prometheus  |     |  Flask API  |
+--------+   +-------------+      +-------------+
                    |                       |
            +-------+-------+               |
            |               |               |    
    +--------------+   +-------------+  +-------------+
    |Node Exporter |   |Postgres Exp.|  | BDD Postgres|
    +--------------+   +-------------+  +-------------+
                            


Liaisons :
- Grafana interroge Prometheus pour les métriques
- Prometheus collecte les métriques depuis Node Exporter et Postgres Exporter
- Postgres Exporter collecte depuis PostgreSQL
- Flask API communique avec PostgreSQL
(frontend et backend sont des réseaux Docker isolés)
```

---
*Projet réalisé pour démonstration d’une stack de monitoring moderne avec reverse proxy nginx.*
