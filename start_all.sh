#!/bin/bash

echo "🌍 Select the environment to start:"
echo "1) Development"
echo "2) Staging"
echo "3) Production"
read -p "👉 Enter your choice [1-3]: " ENV_OPTION

case $ENV_OPTION in
  1)
    ENV_NAME="dev"
    COMPOSE_FILE="docker-compose.dev.yml"
    ;;
  2)
    ENV_NAME="staging"
    COMPOSE_FILE="docker-compose.staging.yml"
    ;;
  3)
    ENV_NAME="prod"
    COMPOSE_FILE="docker-compose.prod.yml"
    ;;
  *)
    echo "❌ Invalid selection. Exiting."
    exit 1
    ;;
esac

ENV_SOURCE_FILE="apps/laravel/.env.${ENV_NAME}"
ENV_TARGET_FILE="apps/laravel/.env"

if [ ! -f "$ENV_SOURCE_FILE" ]; then
  echo "❌ Missing $ENV_SOURCE_FILE"
  exit 1
fi

echo "🔁 Syncing env file for [$ENV_NAME]..."
cp "$ENV_SOURCE_FILE" "$ENV_TARGET_FILE"

echo "🛑 Stopping and removing existing containers..."
docker stop $(docker ps -q) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null

echo "🧹 Removing old images..."
docker rmi -f laravel-devops-lab-app laravel-devops-lab-horizon laravel-devops-lab-queue 2>/dev/null

echo "🚀 Starting Laravel DevOps Lab Environment in [$ENV_NAME] mode..."

echo "👉 Starting main app..."
docker compose -f "$COMPOSE_FILE" up -d --build

echo "📈 Starting monitoring stack..."
docker compose -f monitoring/docker-compose.monitoring.yml up -d --build

echo "🪵 Starting logging stack (Loki)..."
docker compose -f monitoring/docker-compose.loki.yml up -d --build

echo "🖥️ Starting unified dashboard (Heimdall)..."
docker compose -f docker-compose.dashboard.yml up -d --build

echo "✅ All services are up for [$ENV_NAME]!"
