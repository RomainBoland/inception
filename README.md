# Inception

A small Docker Compose infrastructure built from scratch: NGINX (TLS termination) → WordPress (PHP-FPM) → MariaDB, each in its own container, each built from a minimal `debian:bookworm-slim` base image (no pre-built application images).

## Architecture

```
Browser --HTTPS(443)--> NGINX --fastcgi(9000)--> WordPress (php-fpm) --3306--> MariaDB
```

- **NGINX** — sole entrypoint. Terminates TLS (self-signed cert, TLSv1.2/1.3 only) on port 443 and proxies `.php` requests to WordPress over FastCGI. No port 80 is exposed — HTTP is intentionally unavailable.
- **WordPress** — runs `php-fpm` only (no bundled web server). Installed via WP-CLI on first boot: creates `wp-config.php`, waits for MariaDB to accept connections, then runs the WordPress install.
- **MariaDB** — initializes its database, application user, and root password on first boot only (guarded by a `.initialized` marker file in the data volume).

Each service is built from its own `Dockerfile` under `srcs/requirements/<service>/`, with an `entrypoint.sh` handling first-boot setup and idempotency.

## Secrets & configuration

- `srcs/.env` (gitignored) — non-sensitive configuration: domain name, DB name, admin usernames, WP title/email. Copy `srcs/.env.example` to `srcs/.env` and fill in your own values.
- `secrets/*.txt` (gitignored) — actual credentials (DB root password, DB app-user password, WP admin password), mounted into containers as Docker secrets at `/run/secrets/...`, never passed as plain environment variables.

Data persists across restarts via bind-mounted volumes at `~/data/db_data` and `~/data/wp_data`.

## Usage

```sh
make        # build images and start the stack
make down   # stop containers
make clean  # stop and remove volumes
make fclean # clean + remove locally built images
make purge  # fclean + wipe persisted data on the host
make re     # fclean + all
```

## Accessing it locally

`DOMAIN_NAME` in `.env` (e.g. `rboland.42.fr`) isn't a real registered domain — it only needs to resolve on your own machine. Map it to loopback in your hosts file:

```
127.0.0.1 rboland.42.fr
```

(`/etc/hosts` on Linux/macOS, `C:\Windows\System32\drivers\etc\hosts` on Windows — the latter requires an elevated editor.)

Then visit `https://rboland.42.fr`. Since the certificate is self-signed (no CA vouches for it — this is expected and required by the project), your browser will show a trust warning; proceeding past it is the intended flow.

**WSL2 note:** if this stack runs inside WSL2 while the browser runs on Windows, the hosts entry goes in the *Windows* hosts file, not WSL2's — the two are separate files, and Windows' `localhost` forwarding carries the request into the WSL2 VM.

## Notes

- The NGINX `.php` location block guards against forwarding requests for nonexistent scripts to php-fpm (`try_files $uri =404;`) before `fastcgi_pass`.
- The self-signed cert is generated once and cached (idempotent across container restarts) rather than regenerated on every boot.
