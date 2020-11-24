#!/bin/bash

sudo apt update
sudo apt install nginx -y

sudo apt install nodejs -y
sudo apt install npm -y

cd /app
sudo npm install
npm start