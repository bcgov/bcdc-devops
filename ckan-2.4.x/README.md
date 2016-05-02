# Vanilla Ckan v2.4.3 - Vagrant
Authors: jared@highwaythreesolutions.com

# Required Software
* VirtualBOX: https://www.virtualbox.org/wiki/Downloads
* Vagrant: http://www.vagrantup.com/downloads

# Setup Host System
1. Install Vagrant on your host machine
    * For how-to instructions on installing Vagrant: https://docs.vagrantup.com/v2/installation/
2. Install VirtualBox on your host machine

# Setup VM with Vagrant
1. Open up a terminal/console window and go to the directory where the 'Vagrantfile' lives

		cd /path/to/vanilla_ckan/ckan-vagrant

2. Before running vagrant, we'll need the virtualbox guest plugin in-order for vb's shared folders to work with the vm

		vagrant plugin install vagrant-vbguest

3. Run Vagrant

		vagrant up

4. For shell access, you can use vagrant's ssh command

		vagrant ssh

    Note*: to use this command, you must be in the same directory as the 'Vagrantfile'

Optional: If you wish to use ssh natively or want to use scp, copy the output from ssh-config to your ssh config file

        vagrant ssh-config >> ~/.ssh/config

    Note*: you will also need to be in the same directory as the 'Vagrantfile' when you run this command

# Setup the Dev Environment
1. Open the ckan-init.sh script in your favourite text editor
	* We'll be copying the commands listed in the script
    * Review output as steps are executed
    * Please read the comments in the script, because they include some important bits that you'll need to follow
2. If you've installed the bcgov vagrant before, please review the differences section at the bottom of this document.


# Creating a Sysadmin account

        paster --plugin=ckan sysadmin add <username> -c /apps/ckan/conf/development.ini

# Startup
1. Run these commands to start ckan after startup:

		. /usr/lib/ckan/default/bin/activate

		pg_ctl -D /usr/lib/ckan/default/data -l /apps/logs/db/db.log start

		/apps/solr/bin/solr start

		datapusher /apps/ckan/conf/datapusher_settings.py &

		paster --plugin=ckan serve /apps/ckan/conf/development.ini &


# Stopping Ckan and Co.
## To stop ckan and datapusher
1. View the processes for ckan and datapusher

        ps aux | grep python

2. Find the process id for ckan (or datapusher) and kill the process

        kill -15 <id>

3. If you're not sure if ckan or datapusher stopped, re-run step 1
    * if you don't see the process you're good
    * if you still see it, try force killing the process

            kill -9 <id>

## To stop solr
        /apps/solr/bin/solr stop -p 8983
## To stop the db
        pg_ctl -D /usr/lib/ckan/default/data stop


# Making contributions to ckan and extensions
TODO


# Google Analytics
1. To use the GA extension, open the development.ini file in any text editor
2. Uncomment the line, near 'ckan.plugins', where it says 'googleanalytics ga-report'
3. Find the 'googleanalytics' settings, and edit the options accordingly
4. Go to the extensions readme: https://github.com/ckan/ckanext-googleanalytics#setting-up-statistics-retrieval-from-google-analytics
    * follow the instructions

# Differences between bcgov install and vanilla installed
1. Port numbers
    * 5050: ckan
    * 8984: host access to solr
        - this is to prevent a conflict if you're also running the bcgov vagrant
        - however, both bcgov and vanilla ckan vms, still use the default solr config
    * 2220: host access to ssh
        - this is to prevent a conflict if you're also running the bcgov vagrant
3. ckan install
    * for this vm, ckan was installed from the github repo using version 2.3.3
    * on the bcgov vm, ckan is installed via pip
    * the reason for the different install was the pip version was throwing errors on the 'db init' paster command, where as the github version didn't have that issue
4. db
    * 'datastore set-permissions' paster command is done for the 'datastore_default' tables
