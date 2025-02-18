#!/bin/bash

echo "Stopping and Removing Containers, Networks, and Volumes..."
docker compose down -v --remove-orphans

echo "Pruning Docker system (images, containers, volumes)..."
docker system prune -a --volumes -f

echo "Removing old MySQL data and temporary files..."
rm -rf docker/mysql/data
rm -rf tmp/pids/server.pid

echo "Rebuilding and Starting Docker Containers..."
docker compose up -d --build

echo "Waiting for services to initialize..."
sleep 10  # Allow some time for the database to initialize

echo "Checking Running Containers..."
docker ps

echo "Checking Logs for Errors..."
docker compose logs app | grep -i "error\|failed\|unauthorized"

