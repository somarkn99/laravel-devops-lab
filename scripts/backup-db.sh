#!/bin/bash

# Settings
CONTAINER_NAME="laravel_mysql"
DB_NAME="laravel"
DB_USER="root"
DB_PASS="root"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

mkdir -p $BACKUP_DIR

docker exec $CONTAINER_NAME \
  mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "✅ Backup successful: $BACKUP_FILE"
else
  echo "❌ Backup failed"
fi
