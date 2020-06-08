#!/bin/sh

cat $1 | sed -s "s@NGINX_IP@$NGINX_IP@g" | kubectl apply -f -
