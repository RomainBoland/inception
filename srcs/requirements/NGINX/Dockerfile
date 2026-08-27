FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx openssl gettext-base netcat-traditional && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /conf/nginx.conf
COPY script/entrypoint.sh /script/entrypoint.sh

RUN chmod +x /script/entrypoint.sh

ENTRYPOINT ["/script/entrypoint.sh"]
