#!/bin/bash

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
		-subj "/CN=${DOMAIN_NAME}" \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt
fi

envsubst '${DOMAIN_NAME}' < /conf/nginx.conf > /etc/nginx/sites-available/default

until nc -z wordpress 9000; do
	sleep 2
done

exec nginx -g "daemon off;"
