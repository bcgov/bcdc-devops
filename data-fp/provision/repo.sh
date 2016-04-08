#!/bin/bash

mkdir /home/vagrant/node_modules
chown vagrant:vagrant /home/vagrant/node_modules
mkdir /home/vagrant/bower_components
chown vagrant:vagrant /home/vagrant/bower_components

su - vagrant -c 'cd /vagrant; git clone https://github.com/bcgov/data-fp.git'

ln -s /home/vagrant/node_modules/ /vagrant/data-fp/node_modules
ln -s /home/vagrant/bower_components/ /vagrant/data-fp/bower_components

su - vagrant -c 'cd /vagrant/data-fp; npm install'
su - vagrant -c 'cd /vagrant/data-fp; bower install'
su - vagrant -c 'cd /vagrant/data-fp; grunt build'