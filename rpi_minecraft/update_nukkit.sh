#!/bin/bash

if [ -z "$1" ]
then
  echo "Error: Nukkit path not provided."
  exit 1
fi

cd "$1"

git pull
docker-compose up --build -d