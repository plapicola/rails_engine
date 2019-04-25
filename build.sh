#!/bin/bash

# Stop existing containers if present and running
docker stop rails_engine_app
docker stop rails_engine_db

# Remove existing network to prevent error
docker network rm rails_engine_1

# Build docker images for app and DB with appropriate tags

docker build -f Dockerfile.app . -t app:latest
docker build -f Dockerfile.db . -t db:latest

# Build network for containers

docker network create rails_engine_1

# Remove existing containers if present
docker rm rails_engine_db
docker rm rails_engine_app

# Create containers

docker create --hostname db --name rails_engine_db --net rails_engine_1 --net-alias db db
docker create --hostname app --name rails_engine_app --net rails_engine_1 --net-alias app -p 80:3000 app

# Start containers

docker start rails_engine_db rails_engine_app

# Setup database for application

docker exec rails_engine_app rails db:create
docker exec rails_engine_app rails db:migrate
docker exec rails_engine_app rails db:seed
echo "Populating sample database... (This may take a while)"
docker exec rails_engine_app rake import

# Notify build completed

echo "Build Complete."
