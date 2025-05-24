#!/bin/bash

echo "🔍 Laravel DevOps Lab Health Checker"
echo "------------------------------------"

# 🐳 Check running containers
echo "✅ Checking running containers..."
docker ps --format "table {{.Names}}\t{{.Status}}" | grep laravel_

echo ""

# ❤️ Check health status of each service
services=("laravel_app_prod" "laravel_nginx_prod" "laravel_mysql_prod" "laravel_redis_prod")
for service in "${services[@]}"
do
    echo "🔎 Checking health for: $service"
    health=$(docker inspect --format='{{json .State.Health.Status}}' $service 2>/dev/null)
    if [[ $health == "\"healthy\"" ]]; then
        echo "✅ $service is healthy."
    elif [[ $health == "\"starting\"" ]]; then
        echo "⏳ $service is starting..."
    elif [[ $health == "\"unhealthy\"" ]]; then
        echo "❌ $service is UNHEALTHY!"
        echo "📋 Last 3 logs from healthcheck:"
        docker inspect --format='{{json .State.Health.Log}}' $service | jq '.[-3:][] | {Start, Output}' 
    else
        echo "⚠️  No healthcheck defined or container not found."
    fi
    echo ""
done

# 🌐 Check HTTP response for NGINX (port 8088)
echo "🌐 Testing HTTP access to http://localhost:8088..."
curl -s -o /dev/null -w "🔁 HTTP Status: %{http_code}\n" http://localhost:8088/

# 🧾 Check Laravel logs (if any errors exist)
echo ""
echo "📜 Last 10 lines of Laravel log (if exists):"
docker exec laravel_app_prod bash -c "tail -n 10 storage/logs/laravel.log 2>/dev/null || echo 'No log file found.'"

echo ""
echo "🧪 Health check complete."
