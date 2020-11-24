#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install nodejs -y
sudo apt-get install npm
cd /app
sudo npm install pm2 -g
npm start
