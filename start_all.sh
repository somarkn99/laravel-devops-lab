#!/bin/bash

echo "🛑 Stopping and removing existing containers..."
docker stop $(docker ps -q)
docker rm $(docker ps -aq)

echo "🧹 Removing old images..."
docker rmi -f laravel-devops-lab-app laravel-devops-lab-horizon laravel-devops-lab-queue 2>/dev/null

echo "🚀 Starting Laravel DevOps Lab Environment..."

echo "👉 Starting main app (prod)..."
docker compose -f docker-compose.prod.yml up -d --build

echo "📈 Starting monitoring stack..."
docker compose -f monitoring/docker-compose.monitoring.yml up -d --build

echo "🪵 Starting logging stack (Loki)..."
docker compose -f monitoring/docker-compose.loki.yml up -d --build

echo "🖥️ Starting unified dashboard (Heimdall)..."
docker compose -f docker-compose.dashboard.yml up -d --build

echo "✅ All services are up!"
