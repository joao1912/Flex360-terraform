#!/bin/bash

BUCKET_NAME="flex360-front-ae8fh"           
NGINX_DIR="/usr/share/nginx/html"                           

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y

aws configure set region us-east-1

aws s3 sync s3://$BUCKET_NAME/ $NGINX_DIR/

DNS=$(aws ssm get-parameter --name /prod/secrets/alb_dns --query "Parameter.Value" --output text)

sudo mkdir -p $NGINX_DIR/static
echo "window.ALB_DNS = '$DNS';" | sudo tee $NGINX_DIR/static/alb-dns-config.js

sudo chown -R nginx:nginx $NGINX_DIR
sudo chmod -R 755 $NGINX_DIR

sudo systemctl restart nginx
sudo systemctl enable nginx

echo "Deploy concluído!"
