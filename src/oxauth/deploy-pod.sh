#!/bin/sh

cat ../src/oxauth/oxauth.yaml | sed -s "s@NGINX_IP@$NGINX_IP@g" | kubectl apply -f -
