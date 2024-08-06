#!/bin/bash

sudo yum update -y

sudo yum install -y docker

sudo usermod -aG docker $USER

# Iniciar e habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

