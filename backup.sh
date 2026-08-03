#!/bin/bash

set -e

POSTGRES_CONTAINER="postgres"
POSTGRES_USER="root"
POSTGRES_DB="drupal"

DRUPAL_VOLUME="drupal-data"

BACKUP_DIR="./backup"
DB_BACKUP="$BACKUP_DIR/drupal_db_backup.sql"
FILES_BACKUP="$BACKUP_DIR/drupal_files_backup.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "===================================="
echo "Starting backup..."
echo "===================================="

echo "Backing up PostgreSQL database..."

docker exec "$POSTGRES_CONTAINER" \
    sh -c "exec pg_dump -U $POSTGRES_USER $POSTGRES_DB" \
    > "$DB_BACKUP"

echo "Database backup completed."

echo "Backing up Drupal files..."

docker run --rm \
    -v "$DRUPAL_VOLUME":/volume \
    -v "$(pwd)/backup":/backup \
    alpine \
    tar czf /backup/drupal_files_backup.tar.gz -C /volume .

echo "Drupal files backup completed."

echo
echo "===================================="
echo "Backup completed successfully!"
echo "Created:"
echo " - $DB_BACKUP"
echo " - $FILES_BACKUP"
echo "===================================="
