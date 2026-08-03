#!/bin/bash

set -e

POSTGRES_CONTAINER="postgres"
POSTGRES_USER="root"
POSTGRES_DB="drupal"

DRUPAL_CONTAINER="drupal"
DRUPAL_VOLUME="drupal-data"

BACKUP_DIR="./backup"
DB_BACKUP="$BACKUP_DIR/drupal_db_backup.sql"
FILES_BACKUP="$BACKUP_DIR/drupal_files_backup.tar.gz"

echo "===================================="
echo "Starting restore..."
echo "===================================="

if [ ! -f "$DB_BACKUP" ]; then
    echo "Error: database backup file was not found:"
    echo "$DB_BACKUP"
    exit 1
fi

if [ ! -f "$FILES_BACKUP" ]; then
    echo "Error: Drupal files backup was not found:"
    echo "$FILES_BACKUP"
    exit 1
fi

echo "Stopping Drupal container..."
docker stop "$DRUPAL_CONTAINER" >/dev/null 2>&1 || true

echo "Restoring Drupal files..."

docker run --rm \
    -v "$DRUPAL_VOLUME":/volume \
    -v "$(pwd)/backup":/backup \
    alpine \
    sh -c "rm -rf /volume/* /volume/.[!.]* /volume/..?* 2>/dev/null || true; \
           tar xzf /backup/drupal_files_backup.tar.gz -C /volume"

echo "Drupal files restored."

echo "Restoring PostgreSQL database..."

docker exec "$POSTGRES_CONTAINER" \
    dropdb -U "$POSTGRES_USER" --if-exists "$POSTGRES_DB"

docker exec "$POSTGRES_CONTAINER" \
    createdb -U "$POSTGRES_USER" "$POSTGRES_DB"

docker exec -i "$POSTGRES_CONTAINER" \
    psql -U "$POSTGRES_USER" "$POSTGRES_DB" \
    < "$DB_BACKUP"

echo "Database restored."

echo "Starting Drupal container..."
docker start "$DRUPAL_CONTAINER" >/dev/null

echo
echo "===================================="
echo "Restore completed successfully!"
echo "Open: http://localhost:8080"
echo "===================================="
