jq=$HOME/.vendor/jq

extract_mongo_url() {
  # Set if not already present.
  if [ -z "${MONGO_URL}" ]; then
    #echo "Pulling MONGO_URL from VCAP_SERVICES"
    # Find the first service key that contains "mongo", then grab the 'url' (or 'uri') key beneath it.
    export MONGO_URL=`echo $VCAP_SERVICES | $jq 'to_entries|map(select(.key|contains("mongo")))[0]|.value[0].credentials|if .url then .url else .uri end|. // empty' | sed -e 's/^"//'  -e 's/"$//'`
  fi
  #echo "MONGO_URL: $MONGO_URL"
}

extract_root_url() {
  if [ -z "${ROOT_URL}" ]; then
    #echo "Pulling ROOT_URL from VCAP_APPLICATION"
    DOMAIN=`echo $VCAP_APPLICATION | $jq '.uris[0]' | sed -e 's/^"//'  -e 's/"$//'`
    export ROOT_URL="http://$DOMAIN"
    #echo "ROOT_URL: $ROOT_URL"
  fi
}

extract_couchdb_url() {
  if [ -z "${COUCHDB_URL}" ]; then
    #echo "Pulling COUCHDB_URL from VCAP_SERVICES"
    # Find the first service key that contains "cloudant", then grab the 'url' (or 'uri') key beneath it.
    export COUCHDB_URL=`echo $VCAP_SERVICES | $jq 'to_entries|map(select(.key|contains("cloudant")))[0]|.value[0].credentials|if .url then .url else .uri end|. // empty'  | sed -e 's/^"//'  -e 's/"$//'`
  fi
}

discover_cluster() {
    if [[ $(awk '/meteorhacks:cluster/' /app/.meteor/packages) ]] && [ -z "${CLUSTER_WORKERS_COUNT}" ]; then
     export CLUSTER_WORKERS_COUNT=auto
    else
    echo "No meteorhacks:cluster config required"
    fi
}

discover_kadira() {
    if [ -f "/app/kadira.settings" ] && [[ $(awk '/meteorhacks:kadira/' /app/.meteor/packages) ]] && [ -z "${KADIRA_APP_ID}" ]; then
      export KADIRA_APP_ID=`awk '/kadira_app_id/{ print $0 }' /app/kadira.settings | awk  -F"=" '{print $2}'`
      export KADIRA_APP_SECRET=`awk '/kadira_app_secret/{ print $0 }' /app/kadira.settings | awk  -F"=" '{print $2}'`
    else
    echo "No automatic meteorhacks:kadira config required"
    fi
}

extract_mongo_url
extract_root_url
extract_couchdb_url
discover_cluster
discover_kadira