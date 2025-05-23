# 📘 Laravel DevOps Lab – RUNBOOK

This runbook provides clear instructions for operating, monitoring, and troubleshooting the Laravel DevOps Lab environment.

---

## 💡 Overview

This environment simulates a real-world Laravel infrastructure using Docker, GitHub Actions, Redis, MySQL, NGINX, Mailhog, and monitoring/logging stacks like Prometheus, Grafana, and Loki.

---

## 🚀 Starting the Environment

### Production

```bash
docker compose -f docker-compose.prod.yml up -d --build
```

Then enter the container:

```bash
docker exec -it laravel_app_prod bash
composer install --optimize-autoloader --no-dev
cp .env.prod .env
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
```

Access the app via:

```
https://localhost
```

> Note: Uses self-signed SSL certificates.

### Development

```bash
docker compose -f docker-compose.dev.yml up -d --build
```

### Staging

```bash
docker compose -f docker-compose.staging.yml up -d --build
```

### Monitoring

```bash
docker compose -f monitoring/docker-compose.monitoring.yml up -d
```

### Logging

```bash
docker compose -f monitoring/docker-compose.loki.yml up -d
```

---

## 🔍 Monitoring Access

- **Grafana**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **cAdvisor**: http://localhost:8080

---

## 🔐 Secured Monitoring Access

Both Grafana and Alertmanager dashboards are protected using NGINX Basic Authentication.

### Access URLs:

- Grafana: [http://localhost:3001](http://localhost:3001)
- Alertmanager: [http://localhost:9094](http://localhost:9094)

You will be prompted to enter a username and password.

To create credentials:

```bash
htpasswd -c monitoring/nginx/.htpasswd admin
```

Credentials file is mounted into the NGINX reverse proxy.

---

## 🪵 Logging Access

- Open Grafana → Explore
- Select data source: `Loki`
- Query: `{job="docker-logs"}`

---

## 🧪 Health Check

### Laravel App (Dev)

- http://localhost:8000 → Should return Laravel homepage
- Check logs:
  ```bash
  docker logs laravel_app
  ```

### Laravel App (Staging)

- http://localhost:8100
- Use `laravel_app_staging` container logs

### Queue Worker

- Check `laravel_queue` or `laravel_queue_staging` logs
- Log file inside container: `/var/www/storage/logs/worker.log`

---

## ✅ Docker Healthchecks

Docker Healthchecks are enabled for all environments (dev, staging, production) on the following services:

| Service | Healthcheck Command                          |
| ------- | -------------------------------------------- |
| app     | `curl -f http://localhost`                   |
| mysql   | `mysqladmin ping -h localhost -uroot -proot` |
| redis   | `redis-cli ping`                             |
| nginx   | `curl -f http://localhost`                   |

Check container health status using:

```bash
docker ps
```

Status column will show: `healthy`, `starting`, or `unhealthy`.

---

### Laravel App (Dev)

- http://localhost:8000 → Should return Laravel homepage
- Check logs:
  ```bash
  docker logs laravel_app
  ```

### Laravel App (Staging)

- http://localhost:8100
- Use `laravel_app_staging` container logs

### Queue Worker

- Check `laravel_queue` or `laravel_queue_staging` logs
- Log file inside container: `/var/www/storage/logs/worker.log`

---

## 🔁 Restart Services

```bash
docker restart <container_name>
```

Examples:

```bash
docker restart laravel_app
docker restart laravel_mysql
docker restart prometheus
```

---

## ⚠️ Common Issues & Fixes

| Issue                       | Possible Fix                                                |
| --------------------------- | ----------------------------------------------------------- |
| Laravel returns 500 error   | Check `.env`, run `php artisan config:clear`, check logs    |
| MySQL connection refused    | Wait for `laravel_mysql` to be up or restart it             |
| No emails received          | Check Mailhog at http://localhost:8025 or 8125              |
| Queue not processing        | Check `queue` container is running and logs are clean       |
| Logs not showing in Grafana | Check if Promtail is running and paths are mounted properly |

---

## 📦 Backups

### Manual Backup

To back up the MySQL database manually:

```bash
./scripts/backup-db.sh
```

The script will create a `.sql` file in the `backups/` directory.

### Restore Backup

From inside the MySQL container:

```bash
docker cp backups/backup_xxx.sql laravel_mysql:/backup.sql
docker exec -it laravel_mysql bash
mysql -uroot -proot laravel < /backup.sql
```

You can also automate this using a cron job or GitHub Actions in future.

**Not yet implemented** – will include backup script and restore plan.

---

## 🔐 Access Credentials

| Tool       | URL                   | Default Login     |
| ---------- | --------------------- | ----------------- |
| Grafana    | http://localhost:3000 | admin / admin     |
| Mailhog    | http://localhost:8025 | No login required |
| Prometheus | http://localhost:9090 | No login required |

---

## 🔗 Useful Links

- Project Repo: [GitHub](https://github.com/YOUR_USERNAME/laravel-devops-lab)
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- Mailhog Dev: http://localhost:8025
- Mailhog Staging: http://localhost:8125

---

_Last updated: May 2025_

---

## 🔐 Basic Authentication (Production)

NGINX uses HTTP Basic Authentication to restrict access.

### Username and Password

- Username: admin
- Password: (set using htpasswd)

### File Location

- `.htpasswd` is mounted into the container at: `/etc/nginx/.htpasswd`

### NGINX Config Snippet

```nginx
auth_basic "Restricted Access";
auth_basic_user_file /etc/nginx/.htpasswd;
```

This applies to all paths under `https://localhost`.

---

## ⚡ Horizon Dashboard

Laravel Horizon is used for managing the queue workers visually.

### Access

- Dev: http://localhost:8000/horizon
- Staging: http://localhost:8100/horizon
- Prod: https://localhost/horizon (protected by Basic Auth)

### Horizon Container

Horizon is running as a separate container:

```bash
docker compose ps | grep horizon
```

### Restart Horizon

```bash
docker restart laravel_horizon
```

Or:

```bash
docker restart laravel_horizon_staging
```

### Monitor Jobs

- Pending, processed, and failed jobs
- Queue load and time performance

Make sure to run `php artisan horizon:install` in your Laravel app and publish config if needed.
