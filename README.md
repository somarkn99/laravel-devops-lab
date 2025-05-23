# Laravel DevOps Lab 🐳🚀

This is a Laravel-based home lab environment designed to simulate a real-world company's DevOps setup.  
The project includes development environment management using Docker, automated CI/CD pipelines via GitHub Actions, and infrastructure-ready service separation.

---

## 🧱 Project Structure

```
laravel-devops-lab/
├── apps/
│   └── laravel/                # Laravel project code
├── docker/
│   ├── nginx/                  # NGINX config
│   └── supervisor/             # Queue worker config
├── .github/
│   └── workflows/              # GitHub Actions (CI/CD)
├── docker-compose.dev.yml     # Development setup
└── README.md
```

---

## ⚙️ Technologies Used

| Tool/Service   | Purpose                                |
| -------------- | -------------------------------------- |
| Laravel        | Main application framework             |
| Docker         | Containerization of all services       |
| Docker Compose | Service orchestration (dev)            |
| MySQL          | Relational database                    |
| Redis          | Cache and queue driver                 |
| NGINX          | Reverse proxy and HTTP server          |
| Mailhog        | Development mail catcher               |
| Supervisor     | Runs Laravel queue worker              |
| GitHub Actions | CI pipeline for testing and deployment |

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

## 🚀 Running the Dev Environment Locally

1. Build and start containers:

   ```bash
   docker compose -f docker-compose.dev.yml up --build -d
   ```

2. Enter the app container:

   ```bash
   docker exec -it laravel_app bash
   ```

3. Set up Laravel:

   ```bash
   composer install
   cp .env.example .env
   php artisan key:generate
   php artisan migrate
   ```

4. Visit your app and services:
   ```
   Laravel App:  http://localhost:8000
   Mailhog UI:   http://localhost:8025
   ```

---

## 📌 Future Improvements

- Add staging and production environments
- Add Prometheus + Grafana for monitoring
- Add centralized logging (Loki / ELK)
- Add backup script and restore plan
- Add CI/CD deployment to VPS using SSH

---

## 📸 Screenshots

> (Add screenshots of your terminal, GitHub Actions run, or browser view of Laravel)

---

## 📚 Author

**Somar Kisen**  
Full Stack Developer | DevOps Learner | GitLab & Docker Enthusiast  
🔗 [LinkedIn](https://www.linkedin.com/in/YOUR_USERNAME) – [GitHub](https://github.com/YOUR_USERNAME)

---

## 📝 License

MIT – Feel free to use this setup for your own learning or projects.
