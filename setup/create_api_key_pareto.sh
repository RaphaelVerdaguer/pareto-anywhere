# Charger les variables d'environnement depuis le fichier .env
source .env

CREDS="elastic:"${ELASTIC_PASSWORD}

echo CREDS: ${CREDS}

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'
curl -X DELETE -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '{"name": "pareto_api_key"}'
curl -X POST -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/*/_clear_cache/?pretty" -H 'Content-Type: application/json'


curl -X POST -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json' -d '
{
    "name": "pareto_api_key",
    "role_descriptors": {
        "role-name": {
            "cluster": ["all"],
            "indices": [{
                "names": ["raddec", "dynamb", "game-of-thrones"],
                "privileges": ["read", "write", "create_index", "maintenance"]
            }]
            }
        }
}'

curl -X GET -k -u ${CREDS} "https://${SERVER_IP}:${ES_PORT}/_security/api_key/?pretty" -H 'Content-Type: application/json'