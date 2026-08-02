#!/bin/bash

set -e

NETWORK_NAME="drupal-network"

POSTGRES_CONTAINER="postgres"
POSTGRES_USER="root"
POSTGRES_PASSWORD="pw-secret-my"
POSTGRES_DB="drupal"
POSTGRES_VOLUME="postgres-data"

DRUPAL_CONTAINER="drupal"
DRUPAL_VOLUME="drupal-data"

echo "===================================="
echo "Starting Drupal environment setup..."
echo "===================================="

# Create Docker network if it does not already exist
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Docker network already exists."
else
    echo "Creating Docker network..."
    docker network create "$NETWORK_NAME"
fi

# Create or start PostgreSQL container
if docker container inspect "$POSTGRES_CONTAINER" >/dev/null 2>&1; then
    echo "PostgreSQL container already exists."
    docker start "$POSTGRES_CONTAINER" >/dev/null 2>&1 || true
else
    echo "Creating PostgreSQL container..."

    docker run -d \
        --name "$POSTGRES_CONTAINER" \
        --network "$NETWORK_NAME" \
        -e POSTGRES_USER="$POSTGRES_USER" \
        -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
        -e POSTGRES_DB="$POSTGRES_DB" \
        -p 5432:5432 \
        -v "$POSTGRES_VOLUME":/var/lib/postgresql \
        postgres:latest
fi

# Create or start Drupal container
if docker container inspect "$DRUPAL_CONTAINER" >/dev/null 2>&1; then
    echo "Drupal container already exists."
    docker start "$DRUPAL_CONTAINER" >/dev/null 2>&1 || true
else
    echo "Creating Drupal container..."

    docker run -d \
        --name "$DRUPAL_CONTAINER" \
        --network "$NETWORK_NAME" \
        -p 8080:80 \
        -v "$DRUPAL_VOLUME":/var/www/html \
        drupal:latest
fi

echo
echo "===================================="
echo "Setup completed successfully!"
echo "Open your browser at:"
echo "http://localhost:8080"
echo "===================================="
