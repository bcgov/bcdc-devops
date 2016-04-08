data-fp Vagrant box
-------------------

This provides a development environment for the data.gov.bc.ca front page.

The development environment uses [Ubuntu 14.04 LTS](https://atlas.hashicorp.com/ubuntu/boxes/trusty64).  It also installs:

- git
- Ruby 2.3.0
- NodeJS 4.x

The latest code on the ```master``` branch from the [data-fp](https://github.com/bcgov/data-fp) repo is created at ```/vagrant/data-fp```.

By default, the private IP address is ```192.168.33.33```.

## Requirements
1. [VirtualBox][0]
2. [Vagrant][1]

## Setup
Clone the repo and run ```vagrant up```.

## Start Jekyll
1. ```cd``` to repo directory
2. ```vagrant ssh```
3. ```cd /vagrant/data-fp```
4. ```grunt dev```
5. View the site at [http://192.168.33.33:4000](http://192.168.33.33:4000).

[0]: https://www.virtualbox.org/
[1]: https://www.vagrantup.com/
[2]: https://github.com/bcgov/data-fp#development
[3]: https://github.com/bcgov/data-fp#starting-jekyll