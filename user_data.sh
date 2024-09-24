#!/bin/bash

sudo yum update -y

sudo yum install -y docker

sudo usermod -aG docker $USER

# Iniciar e habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

mkdir -p /config/env

# executar comando para buscar as envs no secret maneger

echo "DB_URL=valor" >> /config/env/.env
echo "DB_USERNAME=valor" >> /config/env/.env
echo "DB_PASSWORD=valor" >> /config/env/.env
echo "PORT=80" >> /config/env/.env
echo "BUCKET=valor" >> /config/env/.env

docker pull joaopedrot1912/flex360:latest

docker run -d -p 80:80 -v /config/env/.env:/app/.env joaopedrot1912/flex360-api