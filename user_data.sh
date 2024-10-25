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

SECRET_KEY=$(aws secretsmanager get-secret-value --secret-id prod/token/secret_key --query "SecretString" --output text)

DB_NAME="flex360db"
#DB_PORT=$(echo "$DB_DATA" | grep '^DB_PORT=' | cut -d '=' -f2)
#DB_HOST=$(echo "$DB_DATA" | grep '^DB_HOST=' | cut -d '=' -f2)

DB_HOST=$(echo "$DB_DATA" | jq -r '.DB_HOST')
DB_PORT=$(echo "$DB_DATA" | jq -r '.DB_PORT')

echo "$DB_DATA" > "$PATH_ENV"

echo "DB_URL=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" >> "$PATH_ENV"

echo "BUCKET=$BUCKET_NAME" >> /config/env/.env

echo "HTTP_ORIGIN=$HTTP_ORIGIN" >> /config/env/.env

echo "SECRET_KEY=$SECRET_KEY" >> /config/env/.env

echo "PROFILE=prod" >> /config/env/.env

docker run -d --restart always -p 80:80 -v /config/env/.env:/app/.env joaopedrot1912/flex360-api