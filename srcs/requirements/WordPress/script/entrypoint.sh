#!/bin/bash

WORDPRESS_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_ADMIN}" \
        --dbpass="${WORDPRESS_PASSWORD}" \
        --dbhost="mariadb" \
        --path="/var/www/html" \
        --allow-root

	until wp db check --path="/var/www/html" --allow-root 2>/dev/null; do
		sleep 2
	done

    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="/var/www/html" \
        --allow-root
fi

exec php-fpm8.2 -F
