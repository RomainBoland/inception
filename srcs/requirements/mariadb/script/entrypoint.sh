#!/bin/bash
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
if [ ! -f /var/lib/mysql/.initialized ]; then
	mariadb-install-db
	mariadbd --user=mysql --skip-networking &
	while ! mariadb-admin ping --silent; do
		sleep 2
	done

	WORDPRESS_PASSWORD=$(cat /run/secrets/db_password)
	ROOT_PASSWORD=$(cat /run/secrets/db_admin_password)

	mariadb <<-EOF
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};
	CREATE USER '${DB_ADMIN}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_ADMIN}'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
	EOF

	mariadb-admin --password="${ROOT_PASSWORD}" shutdown
	touch /var/lib/mysql/.initialized
fi

exec mariadbd --user=mysql
