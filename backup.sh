#!/bin/bash

set -e

BACKUP_DIR="./backup"

mkdir -p "$BACKUP_DIR"

echo "Creating database backup..."

docker exec postgres pg_dump -U root drupal > "$BACKUP_DIR/drupal.sql"

echo "Creating Drupal files backup..."

docker run --rm \
    -v drupal-data:/data \
    -v "$(pwd)/backup":/backup \
    alpine \
    tar czf /backup/drupal-files.tar.gz -C /data .

echo
echo "Backup completed successfully!"
echo "Files saved in:"
echo "$BACKUP_DIR"
