#!/bin/bash

set -e

NETWORK_NAME="drupal-network"

POSTGRES_CONTAINER="postgres"
DRUPAL_CONTAINER="drupal"

POSTGRES_VOLUME="postgres-data"
DRUPAL_VOLUME="drupal-data"

POSTGRES_IMAGE="postgres:latest"
DRUPAL_IMAGE="drupal:latest"
ALPINE_IMAGE="alpine:latest"

echo "===================================="
echo "Starting cleanup..."
echo "===================================="

echo "Removing containers..."
docker rm -f "$DRUPAL_CONTAINER" >/dev/null 2>&1 || true
docker rm -f "$POSTGRES_CONTAINER" >/dev/null 2>&1 || true

echo "Removing volumes..."
docker volume rm "$DRUPAL_VOLUME" >/dev/null 2>&1 || true
docker volume rm "$POSTGRES_VOLUME" >/dev/null 2>&1 || true

echo "Removing Docker network..."
docker network rm "$NETWORK_NAME" >/dev/null 2>&1 || true

echo "Removing Docker images..."
docker image rm "$DRUPAL_IMAGE" >/dev/null 2>&1 || true
docker image rm "$POSTGRES_IMAGE" >/dev/null 2>&1 || true
docker image rm "$ALPINE_IMAGE" >/dev/null 2>&1 || true

echo
echo "===================================="
echo "Cleanup completed successfully!"
echo "===================================="
