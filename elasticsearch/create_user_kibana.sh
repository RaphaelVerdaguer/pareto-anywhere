#!/bin/bash

#read and export .env
ENV_PATH=../
export $(grep -v '^#' $ENV_PATH.env | xargs)

docker cp pareto-anywhere-setup-1:/usr/share/elasticsearch/config/certs/ca/ca.crt .

#ok
#curl -X POST --insecure --cacert ./ca.crt "https://192.168.1.34:9200/_security/user/$RAPHAEL_USER" -u "elastic:$ELASTIC_PASSWORD" -H "Content-Type: application/json" -d '{"password": "'$RAPHAEL_PASSWORD'", "enabled": true, "roles": ["superuser", "kibana_admin"], "full_name": "'$RAPHAEL_USER'", "email": "", "metadata": {"intelligence": 1}}'
#ok docker
#curl -X POST --cacert config/certs/ca/ca.crt "https://es01:9200/_security/user/${RAPHAEL_USER}" -u "elastic:${ELASTIC_PASSWORD}" -H "Content-Type: application/json" -d "{\"password\": \"${RAPHAEL_PASSWORD}\", \"enabled\": true, \"roles\": [\"superuser\", \"kibana_admin\"], \"full_name\": \"${RAPHAEL_USER}\", \"email\": \"\", \"metadata\": {\"intelligence\": 1}}"
#ok 2
curl -X POST --insecure --cacert ./ca.crt "https://192.168.1.34:9200/_security/user/$RAPHAEL_USER" -u "elastic:$ELASTIC_PASSWORD" -H "Content-Type: application/json" -d "{\"password\": \"$RAPHAEL_PASSWORD\", \"enabled\": true, \"roles\": [\"superuser\", \"kibana_admin\"], \"full_name\": \"$RAPHAEL_USER\", \"email\": \"\", \"metadata\": {\"intelligence\": 1}}"
  