# BCDC + Vagrant
Authors:leo.lou@gov.bc.ca, jared@highwaythreesolutions.com
Version:0.0.2

# Required Software
* VirtualBOX: https://www.virtualbox.org/wiki/Downloads
* Vagrant: http://www.vagrantup.com/downloads
* SSH
* SVN
* Cisco VPN (if not on Span/BC network already - for svn access & download of dump files)
* [REMOVE - vagrant does this] CentOS BOX file: https://atlas.hashicorp.com/bento/boxes/centos-6.7

# Setup Host System
1. Install Vagrant on your host machine
    * For how-to instructions on installing Vagrant https://docs.vagrantup.com/v2/installation/
2. Install VirtualBox on your host machine

# Setup VM with Vagrant
1. Checkout/export the svn repos 
    * svn co http://apps.bcgov/svn/edc/bcdc-vagrant/ 
    * svn co http://apps.bcgov/svn/edc/config
		* Note: Karen: you don't need this repo for now, it's just for the dlv.ini file
2. Download the db dump files
    * https://delivery.apps.gov.bc.ca/ext/sgw/edclogs/pgdump/ckan.20160112.pgdump
	* https://delivery.apps.gov.bc.ca/ext/sgw/edclogs/pgdump/datastore.20160112.pgdump
	* Note: these are db dumbs from delivery
3. Go into the bcdc-vagrant repo to the vagrant file location on your system
	* cd bcdc-vagrant/bcdc-vagrant
4. Run Vagrant
	* vagrant up
    	* this may take some time, depending on your WLAN connection
    	* Note: Once installed, to launch the vm, use VirtualBox, don't run vagrant up again, it will reset the vm
5. Copy the ssh-config output to make it easier to ssh or scp to the vm
        vagrant ssh-config > ~/.ssh/config
        * To log into the vm
        ssh default 
		
# Setup the Dev Environment
1. Copy these files over to your vm (i would use scp, see step 5 in Setup VM with Vagrant).  Local directory will be based on the svn co in step 1 of VM setup:
    scp ./config/delivery/trunk/ckan/vagrant_dlv.ini default:/tmp
    scp ckan.20160112.pgdump default:/tmp
    scp datastore.20160112.pgdump default:/tmp
2. Copy the dlv.ini into the correct location on the vm
    ssh default
    mkdir -p /apps/ckan/conf    
    cp /tmp/vagrant_dlv.ini /apps/ckan/conf/dlv.ini
3. Open the bcdc-init.sh script in your favourite text editor
	* We'll be copying the cmds listed in the script, at the moment there are parts that need additional setup or require command line entry.  Review output as steps are executed.
	
# Post setup to bypass EAS/login directly
# Fixing the login
- in the ckanext-bcgov repo -> ckanext/bcgov/templates/snippets/main-navigation.html
	- the login block needs to be changed back to what is default in ckan
```
<nav class="account not-authed">
	<ul class="unstyled">
	{% block header_account_notlogged %}
		{% block header_account_notlogged_login %}
		<li><a href="{{ h.get_eas_login_url() }}">Log in</a></li>
		{% endblock %}
	{% endblock %}
	</ul>
</nav>
```
	- change to:
```
<nav class="account not-authed">
    <ul class="unstyled">
	{% block header_account_notlogged %}
		<li>{% link_for _('Log in'), controller='user', action='login' %}</li>
		{% if h.check_access('user_create') %}
			<li>{% link_for _('Register'), controller='user', action='register', class_='sub' %}</li>
		{% endif %}
	{% endblock %}
    </ul>
</nav>
```
- will need to set up a user if you don't have one from the delivery import?
	- paster --plugin=ckan sysadmin add <username> -c /apps/ckan/conf/dlv.ini
		- enter a password
		- serve ckan
		- login to ckan with your user
			- go to your dashboard, and try to find the api key (should be on the left sidebar)
			- copy the api key and replace the ckan.api_key in /apps/ckan/conf/dlv.ini


