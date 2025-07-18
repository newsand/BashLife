#!/bin/bash

# Exit on any error
set -e

# Navigate to the project directory
cd /home/appuser/admin-backend

# Pull the latest code from the repository
echo "Pulling latest code from Git..."
sudo -u appuser git stash
sudo -u appuser git pull

# Stop and remove the existing Docker Compose services
echo "Stopping and removing existing Docker Compose services..."
echo "Stopping admin-frontend.service..."
systemctl stop admin-frontend.service

# Remove existing Docker images to ensure a clean build
echo "Removing existing Docker images..."
docker images -q | grep -E "^$(docker compose config --images | awk '{print $1}' | uniq)" | xargs --no-run-if-empty docker rmi -f

# Rebuild and start Docker Compose services with no cache
echo "Rebuilding and starting Docker Compose services..."
docker compose build --no-cache
docker compose up -d

# Restart the systemd service
echo "Restarting admin-frontend.service..."
systemctl start admin-frontend.service

echo "Redeploy completed successfully!"