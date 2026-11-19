FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends php-fpm php-mysqli wget ca-certificates tar mariadb-client && rm -rf /var/lib/apt/lists/*

RUN sed -i "s|^listen = .*|listen = 9000|" /etc/php/8.2/fpm/pool.d/www.conf

RUN wget -q -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp


RUN mkdir -p /var/www && \
	wget -q -O wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
	tar -xzf wordpress.tar.gz -C /var/www/ && \
	mv /var/www/wordpress /var/www/html && \
	rm wordpress.tar.gz

COPY script/entrypoint.sh /script/entrypoint.sh

RUN chmod +x /script/entrypoint.sh

ENTRYPOINT ["/script/entrypoint.sh"]