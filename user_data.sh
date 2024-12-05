#!/bin/bash

sudo yum update -y

sudo yum install -y docker jq

sudo usermod -aG docker $USER

# Iniciar e habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

mkdir -p /config/env

aws configure set region us-east-1

PATH_ENV="/config/env/.env"

#DB_DATA=$(aws secretsmanager get-secret-value --secret-id secrets_database --query "SecretString" --output text | jq -r '. | to_entries[] | "\(.key)=\(.value)"')

DB_DATA=$(aws ssm get-parameter --name /prod/secrets/database --with-decryption --query "Parameter.Value" --output text)

HTTP_ORIGIN=$(aws ssm get-parameter --name front-flex360-origin --query "Parameter.Value" --output text)

BUCKET_NAME=$(aws ssm get-parameter --name bucket-flex360 --query "Parameter.Value" --output text)

SECRET_KEY=$(aws secretsmanager get-secret-value --secret-id prod/token/secret_key --query "SecretString" --output text | jq -r '.secret_key_token')

DB_NAME="flex360db"
DB_HOST=$(echo "$DB_DATA" | jq -r '.DB_HOST')
DB_PORT=$(echo "$DB_DATA" | jq -r '.DB_PORT')
DB_USERNAME=$(echo "$DB_DATA" | jq -r '.DB_USERNAME')
DB_PASSWORD=$(echo "$DB_DATA" | jq -r '.DB_PASSWORD')

echo "BUCKET=$BUCKET_NAME" >> "$PATH_ENV"
echo "HTTP_ORIGIN=$HTTP_ORIGIN" >> "$PATH_ENV"
echo "SECRET_KEY=$SECRET_KEY" >> "$PATH_ENV"

yum install -y amazon-ssm-agent

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

docker run -d --restart always -p 80:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e DB_URL="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
  -e DB_USERNAME="$DB_USERNAME" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e PORT=8080 \
  -e DB_PORT="$DB_PORT" \
  joaopedrot1912/flex360-api
