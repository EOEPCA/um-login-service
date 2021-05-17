#!/usr/bin/env bash


USAGE="Usage: id.sh -t <token_endpoint> -i <client_id> -p <client_secret>" 
TOKEN_ENDPOINT=""
HTTP="http://"
TICKET=""
CLIENT_ID=""
CLIENT_SECRET=""
SCOPES=""
SPACE="%20"
CLAIM_TOKEN=""
echo "JESUS HA SIDO CREADO" > $PWD/alvl.txt
echo "wth"
while getopts ":t:i:p:" opt; do
  case ${opt} in
    t ) TOKEN_ENDPOINT=$OPTARG
      ;;
    i ) CLIENT_ID=$OPTARG
      ;;
    p ) CLIENT_SECRET=$OPTARG
      ;;
    \? )
        echo "Invalid option: -$OPTARG" 1>&2
        echo "$USAGE"
        exit 1
      ;;
  esac
done

echo $TOKEN_ENDPOINT
echo $CLIENT_ID
echo $CLIENT_SECRET
curl -k -v -XPOST $TOKEN_ENDPOINT -H "cache-control: no-cache" -d "scope=openid%20user_name&grant_type=password&username=admin&password=admin_Abcd1234%23&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" > $PWD/1.txt
