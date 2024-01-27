#!/bin/bash

# Vérifier si Docker Compose est déjà installé
if command dpkg-query -l | grep docker-compose-plugin &> /dev/null; then
    echo "Docker Compose already inslalled"
else
    # Installer Docker Compose
    echo "Docker Compose not inslalled. Installing..."
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg lsb-release -y
    sudo apt-get install curl -y
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y   
    wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.21.1-amd64.deb
    sudo apt-get install ./docker-desktop-*.deb -y
    rm ./docker-desktop-*.deb
    # Vérifier si l'installation s'est bien déroulée
    if command -v docker compose &> /dev/null; then
        echo "Docker Compose installation succes."
    else
        echo "Error when installing Docker Compose."
    fi
fi
