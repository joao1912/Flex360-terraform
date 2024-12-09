#!/bin/bash

BUCKET_NAME="flex360-front-ae8fh"           
NGINX_DIR="/usr/share/nginx/html"            
NGINX_CONF="/etc/nginx/nginx.conf"               

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y

aws configure set region us-east-1

aws s3 sync s3://$BUCKET_NAME/ $NGINX_DIR/

DNS=$(aws ssm get-parameter --name /prod/secrets/alb_dns --query "Parameter.Value" --output text)

sudo mkdir -p $NGINX_DIR/static
echo "window.ALB_DNS = '$DNS';" | sudo tee $NGINX_DIR/static/alb-dns-config.js

sudo chown -R nginx:nginx $NGINX_DIR
sudo chmod -R 755 $NGINX_DIR

sudo tee $NGINX_CONF > /dev/null <<EOF

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        location / {
          try_files \$uri /index.html;
        }

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

}

EOF

sudo systemctl restart nginx
sudo systemctl enable nginx

echo "Deploy concluído!"
