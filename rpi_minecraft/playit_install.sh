#!/bin/bash

echo "Adding PlayIt repository"
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list

echo "Installing PlayIt"
sudo apt update
sudo apt install playit

echo "Configuring playit to run automatically" 
sudo systemctl start playit
sudo systemctl enable playit

echo "To access the claim code run: \"playit setup\""


