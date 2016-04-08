#!/bin/bash

apt-get update
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
apt-get install -y git
npm install -g bower
npm install -g grunt
su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
su - vagrant -c 'curl -L https://get.rvm.io | bash -s stable'
su - vagrant -c 'source ~/.rvm/scripts/rvm'
su - vagrant -c 'rvm install 2.3.0'
su - vagrant -c 'rvm use 2.3.0 --default'
su - vagrant -c 'gem install jekyll'