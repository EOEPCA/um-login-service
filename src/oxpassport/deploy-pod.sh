#!/bin/sh

cat ../src/oxpassport/oxpassport.yaml | sed -s "s@NGINX_IP@$NGINX_IP@g" | kubectl apply -f -
