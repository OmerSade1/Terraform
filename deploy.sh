#!/bin/bash
yum install docker -y
systemctl enable --now docker
usermod -a -G docker ec2-user
newgrp docker
export PATH=$PATH:/usr/local/bin
docker pull omersade/netflix_frontend:latest
docker pull omersade/netflix_catalog:latest
docker network create netflix
docker run -d -p 8080:8080 --network netflix --name netflix_catalog omersade/netflix_catalog:latest
docker run -d -p 3000:3000 --network netflix -e MOVIE_CATALOG_SERVICE=http://netflix_catalog:8080 --name netflix_frontend omersade/netflix_frontend:latest

