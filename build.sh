#!/bin/bash

echo "Pruning Docker system (images, containers, volumes)..."
docker system prune -a --volumes -f

echo "Building and Starting Docker Containers..."
docker compose build --no-cache && docker compose up -d --build

echo "build is done"
