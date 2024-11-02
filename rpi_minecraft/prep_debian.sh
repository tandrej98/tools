#!/bin/bash

echo "Updating and upgrading the system"
sudo apt update
sudo apt upgrade

echo "Installing default-jdk and git"
sudo apt install default-jdk git

echo "Installing Docker"
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER
