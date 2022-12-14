#!/bin/bash

sudo apt update 
#install git
sudo apt install git curl -y
sleep 5

#install docker 
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo apt install docker-compose -y 
sleep 5

#clone repository
git clone https://github.com/Munney84/ifme.git
sleep 5
cd /ifme

sudo apt update
#create keyring directory and get keys
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

docker-compose build
docker-compose run app rake db:create db:migrate db:seed
sleep 5

docker-compose up && \
docker-compose exec app bundle exec rails assets:precompile

