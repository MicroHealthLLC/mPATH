#!/bin/bash

echo "Stopping and Removing Containers, Networks, and Volumes..."
docker compose down -v --remove-orphans

echo "Pruning Docker system (images, containers, volumes)..."
docker system prune -a --volumes -f

echo "Removing old MySQL data and temporary files..."
rm -rf docker/mysql/data
rm -rf tmp/pids/server.pid

echo "Rebuilding and Starting Docker Containers..."
docker compose build --no-cache && docker compose up -d --build

echo "rebuild is done"
