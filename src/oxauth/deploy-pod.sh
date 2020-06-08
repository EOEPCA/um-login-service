#!/bin/sh
# $1 should be the oxauth.yaml config
cat $1 | sed -s "s@NGINX_IP@$NGINX_IP@g" | kubectl apply -f -
