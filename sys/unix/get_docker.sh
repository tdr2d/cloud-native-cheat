#!/bin/bash

curl https://get.docker.com/ | sh

# Postinstall docker as non root
sudo groupadd docker
sudo usermod -aG docker $USER

# Test
docker run hello-world


echo "To use docker in your current tty:"
echo "newgrp docker"
