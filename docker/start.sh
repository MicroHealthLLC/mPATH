#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

# Create a Docker network if it doesn't exist
docker network inspect mpath-network >/dev/null 2>&1 || \
    docker network create mpath-network

# Build Docker images from the current folder
echo "Building Docker images..."
docker build -t mpath-mysql ./mysql
docker build -t mpath-nginx ./nginx
docker build -t mpath-app ./app

# Function to check if a container is running
wait_for_container() {
    local container_name=$1
    echo "Waiting for $container_name to be healthy..."
    while ! docker inspect --format='{{.State.Health.Status}}' $container_name 2>/dev/null | grep -q 'healthy'; do
        sleep 5
    done
    echo "$container_name is healthy!"
}

# Start MySQL Container
echo "Starting MySQL container..."
docker run -d --name mysql --network mpath-network \
    -e MYSQL_DATABASE=mpath \
    -e MYSQL_USER=mpath_user \
    -e MYSQL_PASSWORD=mpath_pass \
    -e MYSQL_ROOT_PASSWORD=root_pass \
    -p 3306:3306 \
    --health-cmd='mysqladmin ping -h localhost' --health-interval=5s --health-timeout=5s --health-retries=5 \
    mpath-mysql

# Wait for MySQL to be healthy
wait_for_container mysql

# Start Application Container
echo "Starting Application container..."
docker run -d --name app --network mpath-network \
    -e DB_HOST=mysql \
    -e DB_USER=mpath_user \
    -e DB_PASSWORD=mpath_pass \
    -e DB_NAME=mpath \
    -p 3000:3000 \
    mpath-app

# Wait for Application to be ready
echo "Waiting for Application to be ready..."
sleep 10  # Adjust this based on app startup time

# Start Nginx Container
echo "Starting Nginx container..."
docker run -d --name nginx --network mpath-network \
    -p 80:80 \
    mpath-nginx

# Done
echo "All containers are up and running!"
