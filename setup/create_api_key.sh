# Charger les variables d'environnement depuis le fichier .env
source .env

CREDS="elastic:"${ELASTIC_PASSWORD}

echo CREDS: ${CREDS}

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'
curl -X DELETE -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '{"name": "ES_PARETO_API_KEY"}'
curl -X DELETE -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '{"name": "ES_BACKEND_API_KEY"}'
curl -X POST -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/*/_clear_cache/?pretty" -H 'Content-Type: application/json'

# Supprimer le fichier API_key.txt s'il existe déjà
rm -f API_key.txt

# Créer la clé ES_PARETO_API_KEY
response=$(curl -X POST -s -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '
{
    "name": "ES_PARETO_API_KEY",
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

# Extraire la clé ES_PARETO_API_KEY de la réponse JSON
ES_PARETO_API_KEY=$(echo "${response}" | grep -oP '(?<="encoded" : ")[^"]*')

# Écrire la clé ES_PARETO_API_KEY dans le fichier API_key.txt
echo "ES_PARETO_API_KEY=${ES_PARETO_API_KEY}" >> API_key.txt

# Créer la clé ES_BACKEND_API_KEY
response=$(curl -X POST -s -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '
{
    "name": "ES_BACKEND_API_KEY",
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

# Extraire la clé ES_BACKEND_API_KEY de la réponse JSON
ES_BACKEND_API_KEY=$(echo "${response}" | grep -oP '(?<="encoded" : ")[^"]*')

# Écrire la clé ES_BACKEND_API_KEY dans le fichier API_key.txt
echo "ES_BACKEND_API_KEY=${ES_BACKEND_API_KEY}" >> API_key.txt

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'

# Afficher le contenu du fichier API_key.txt
cat API_key.txt

# Remplacer la valeur de ES_PARETO_API_KEY dans le fichier .env
sed -i "s/^ES_PARETO_API_KEY=.*/ES_PARETO_API_KEY=${ES_PARETO_API_KEY}/" .env

# Remplacer la valeur de ES_BACKEND_API_KEY dans le fichier ../app-ble-backend/.env
sed -i "s/^ES_BACKEND_API_KEY=.*/ES_BACKEND_API_KEY=${ES_BACKEND_API_KEY}/" ../app-ble-backend/.env
# Remplacer la valeur de ES_BACKEND_API_KEY dans le fichier ../app-ble-backend/.env.test
sed -i "s/^ES_BACKEND_API_KEY=.*/ES_BACKEND_API_KEY=${ES_BACKEND_API_KEY}/" ../app-ble-backend/.env.test
# Remplacer la valeur de ES_BACKEND_API_KEY dans le fichier ../app-ble-backend/.env.development
sed -i "s/^ES_BACKEND_API_KEY=.*/ES_BACKEND_API_KEY=${ES_BACKEND_API_KEY}/" ../app-ble-backend/.env.development