# Laravel DevOps Lab 🐳🚀

This is a Laravel-based home lab environment designed to simulate a real-world company's DevOps setup.  
The project includes development environment management using Docker, automated CI/CD pipelines via GitHub Actions, monitoring with Prometheus & Grafana, and centralized logging with Loki.

---

## 🧱 Project Structure

```
laravel-devops-lab/
├── apps/
│   └── laravel/                # Laravel project code
├── docker/
│   ├── nginx/                  # NGINX config
│   └── supervisor/             # Queue worker config
├── monitoring/
│   ├── docker-compose.monitoring.yml  # Prometheus + Grafana
│   ├── docker-compose.loki.yml        # Loki + Promtail
│   ├── prometheus.yml
│   └── promtail-config.yml
├── .github/
│   └── workflows/              # GitHub Actions (CI/CD)
├── docker-compose.dev.yml     # Development environment
├── docker-compose.staging.yml # Staging environment
└── README.md
```

---

## ⚙️ Technologies Used

| Tool/Service   | Purpose                                |
| -------------- | -------------------------------------- |
| Laravel        | Main application framework             |
| Docker         | Containerization of all services       |
| Docker Compose | Service orchestration (dev & staging)  |
| MySQL          | Relational database                    |
| Redis          | Cache and queue driver                 |
| NGINX          | Reverse proxy and HTTP server          |
| Mailhog        | Development mail catcher               |
| Supervisor     | Runs Laravel queue worker              |
| GitHub Actions | CI pipeline for testing and deployment |
| Prometheus     | Time-series database for monitoring    |
| Grafana        | Visualize metrics and logs             |
| cAdvisor       | Expose container metrics to Prometheus |
| Loki           | Centralized log aggregation system     |
| Promtail       | Log collector that ships to Loki       |

---

## 🧪 CI/CD Pipeline (GitHub Actions)

This project includes a GitHub Actions workflow that runs on every push to the `dev` branch.

**Pipeline steps:**

1. Checkout code
2. Set up PHP 8.2
3. Install Composer dependencies
4. Generate app key
5. Run tests (if present)
6. ✅ Placeholder for future deployment

You can find the workflow file at:

```
.github/workflows/dev.yml
```

---

## 🚀 Running the Dev Environment

```bash
docker compose -f docker-compose.dev.yml up --build -d
```

Access:

- Laravel App: http://localhost:8000
- Mailhog UI: http://localhost:8025

---

## 🚀 Running the Staging Environment

```bash
docker compose -f docker-compose.staging.yml up --build -d
```

Access:

- Laravel App (Staging): http://localhost:8100
- Mailhog (Staging): http://localhost:8125

---

## 📈 Monitoring Stack (Prometheus + Grafana + cAdvisor)

```bash
docker compose -f monitoring/docker-compose.monitoring.yml up -d
```

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- cAdvisor: http://localhost:8080

---

## 🪵 Logging Stack (Loki + Promtail + Grafana)

```bash
docker compose -f monitoring/docker-compose.loki.yml up -d
```

- Explore logs via Grafana → Explore → {job="docker-logs"}

---

## 📌 Future Improvements

- Add production environment
- Add Runbook (incident handling instructions)
- Add backup script and restore plan
- Add CI/CD deployment to VPS using SSH

---

## 💾 Backup Script

A simple backup script is available in the `scripts/` directory. It exports the MySQL database to a `.sql` file with timestamp.

### Run a manual backup:

```bash
./scripts/backup-db.sh
```

### Output:

Backups are stored in the `backups/` directory, e.g.:

```
backups/backup_2025-05-23_18-50-00.sql
```

---

## 📸 Screenshots

> (Add screenshots of your dashboards, logs, and app views)

---

## 📚 Author

**Somar Kisen**  
Full Stack Developer | DevOps Learner | GitLab & Docker Enthusiast  
🔗 [LinkedIn](https://www.linkedin.com/in/YOUR_USERNAME) – [GitHub](https://github.com/YOUR_USERNAME)

---

## 📝 License

MIT – Feel free to use this setup for your own learning or projects.
