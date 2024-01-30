# Charger les variables d'environnement depuis le fichier .env
source ../.env

CREDS="elastic:"${ELASTIC_PASSWORD}

echo CREDS: ${CREDS}

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'
curl -X DELETE -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '{"name": "pareto_api_key"}'
curl -X POST -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/*/_clear_cache/?pretty" -H 'Content-Type: application/json'

# Supprimer le fichier API_key.txt s'il existe déjà
rm -f API_key.txt

# Créer la clé PARETO_API_KEY
response=$(curl -X POST -s -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '
{
    "name": "pareto_api_key",
    "role_descriptors": {
        "role-prod": {
            "cluster": ["all"],
            "indices": [{
                "names": ["raddec", "dynamb", "game-of-thrones"],
                "privileges": ["read", "write", "create_index", "maintenance"]
            }]
        }
    }
}')

# Extraire la clé PARETO_API_KEY de la réponse JSON
pareto_api_key=$(echo "${response}" | grep -oP '(?<="encoded" : ")[^"]*')

# Écrire la clé PARETO_API_KEY dans le fichier API_key.txt
echo "PARETO_API_KEY=${pareto_api_key}" >> API_key.txt

# Créer la clé BACKEND_API_KEY
response=$(curl -X POST -s -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '
{
    "name": "backend_api_key",
    "role_descriptors": {
        "role-prod": {
            "cluster": ["all"],
            "indices": [{
                "names": ["beacon-signals", "establishments", "equipments-*", "maps-*", "pairings-*", "routers-*", "users-*"],
                "privileges": ["all"]
            }]
        },
        "role-pareto-indices": {
            "cluster": ["all"],
            "indices": [{
                "names": ["dynamb", "raddec"],
                "privileges": ["read"]
            }]
        },
        "role-test": {
            "cluster": ["all"],
            "indices": [{
                "names": ["test-*"],
                "privileges": ["all"]
            }]
        }
    }
}')

# Extraire la clé BACKEND_API_KEY de la réponse JSON
backend_api_key=$(echo "${response}" | grep -oP '(?<="encoded" : ")[^"]*')

# Écrire la clé BACKEND_API_KEY dans le fichier API_key.txt
echo "BACKEND_API_KEY=${backend_api_key}" >> API_key.txt

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'

# Afficher le contenu du fichier API_key.txt
cat API_key.txt