# Inception

A Docker-based infrastructure project that deploys a WordPress site served over HTTPS, using three isolated containers orchestrated with Docker Compose.

## Architecture

```
                 ┌─────────────────────────────────────────────┐
                 │             inception_net (bridge)          │
                 │                                             │
  HTTPS :443 ──► │  nginx ──► wordpress (php-fpm) ──► mariadb  │
                 │                                             │
                 └─────────────────────────────────────────────┘
```

| Container   | Base Image       | Role                          |
|-------------|------------------|-------------------------------|
| `nginx`     | debian:bullseye  | Reverse proxy, TLS termination |
| `wordpress` | debian:bullseye  | PHP-FPM application server    |
| `mariadb`   | debian:bullseye  | MySQL-compatible database     |

### Volumes

| Volume name        | Host path                          | Used by             |
|--------------------|------------------------------------|---------------------|
| `wp-and-nginx-dir` | `/home/fgabler/data/wp_and_nginx_dir` | nginx, wordpress |
| `mariadb-vol`      | `/home/fgabler/data/mariadb-dir`   | mariadb             |

### Secrets

Passwords are stored as Docker secrets (plain-text files) and are **never** passed as environment variables:

| Secret file               | Consumed by           | Purpose                    |
|---------------------------|-----------------------|----------------------------|
| `secrets/maria-pass.txt`  | mariadb, wordpress    | MariaDB application user   |
| `secrets/sql_root_pass.txt` | mariadb             | MariaDB root password      |
| `secrets/wp-db-user-pass.txt` | wordpress         | WordPress admin password   |
| `secrets/author_pass.txt` | wordpress             | WordPress author password  |

## Prerequisites

- Docker ≥ 20.10
- Docker Compose v2 (`docker compose`)
- `openssl` (used inside the nginx build)
- `sudo` access (required by `rm-dir` to clean volume paths)

## Quick Start

### 1. Create secret files

```bash
make secret_files
```

This creates `secrets/` and pre-fills every file with `1234`.  
**Change the passwords before running in any non-local environment.**

### 2. Configure environment variables

Create `srcs/.env` based on the variables expected by the containers:

```env
MARIADB_DATABASE=wordpress
MARIADB_USER=wp_user
WP_DB_USER=admin
WP_DB_EMAIL=admin@example.com
AUTHOR_NAME=author
AUTHOR_MAIL=author@example.com
```

### 3. Build and start

```bash
# Build images and start in the foreground
make up

# Or build and start detached
make up-d
```

The site will be reachable at **https://fgabler.42.fr** (add the host to `/etc/hosts` if needed).

## Makefile Targets

| Target         | Description                                         |
|----------------|-----------------------------------------------------|
| `up`           | Create data dirs, start containers (foreground)     |
| `up-d`         | Create data dirs, start containers (detached)       |
| `down`         | Stop and remove containers                          |
| `build`        | Build all images without starting                   |
| `re`           | `down` → `build` → `up`                             |
| `re-d`         | `down` → `build` → `up-d`                           |
| `secret_files` | Scaffold secrets directory with placeholder values  |
| `rm-dir`       | Remove local volume directories                     |
| `rm-vol`       | Remove named Docker volumes                         |
| `rm-all`       | `docker system prune -a` (removes everything)       |

## Container Details

### MariaDB

- Installed from the Debian package `mariadb-server`.
- `user-init.sh` runs at startup:
  - Creates the application database and user.
  - Sets the root password.
  - Binds `mariadb` to its container hostname so WordPress can reach it.
- A `healthcheck.sh` script is used by Docker Compose to gate the WordPress startup.

### WordPress

- Runs **PHP-FPM 7.4** on port `9000`.
- `dowload_wp_cli.sh` runs at startup:
  - Downloads and installs [WP-CLI](https://wp-cli.org/).
  - Downloads WordPress core (idempotent).
  - Creates `wp-config.php` (idempotent).
  - Installs WordPress (idempotent).
  - Creates an author user (idempotent).
- Depends on MariaDB being healthy before starting.

### Nginx

- Serves HTTPS on port `443` only.
- A self-signed TLS certificate (`RSA 2048`) is generated at image build time.
- Proxies all `.php` requests to the `wordpress` container via FastCGI.
- Static files are served directly from the shared `wp-and-nginx-dir` volume.

## Project Structure

```
.
├── Makefile
├── secrets/                     # Git-ignored password files
└── srcs/
    ├── .env                     # Environment variables (git-ignored)
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── mariadb.Dockerfile
        │   └── tools/
        │       ├── healthcheck.sh
        │       └── user-init.sh
        ├── nginx/
        │   ├── nginx.Dockerfile
        │   └── conf/
        │       └── nginx.conf
        └── wordpress/
            ├── wordpress.Dockerfile
            ├── config/
            │   └── www.conf
            └── tools/
                └── dowload_wp_cli.sh
```
