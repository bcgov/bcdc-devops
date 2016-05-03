#!export/bin/sh
#author: Highway Three Solutions (Jared Smith/Karen Fishwick)

## Installing CKAN

# Adjusting path environments
echo 'export JAVA_HOME=/usr/java/latest' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH:/usr/pgsql-9.1/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH==$JAVA_HOME/lib:$LD_LIBRARY_PATH:/usr/pgsql-9.1/lib' >> ~/.bashrc
source ~/.bashrc

# copy config files from vagrant
mkdir -p /apps/ckan/conf
cp /usr/local/install_data/conf/{datapusher_settings.py,development.ini} /apps/ckan/conf/
# log location for ckan
mkdir -p /apps/logs/{ckan,db}

# allows ckan to be in the user's home directory
# while still being able to use copy-paste example commands
mkdir -p ~/ckan/lib
sudo ln -s ~/ckan/lib /usr/lib/ckan
mkdir -p ~/ckan/etc
sudo ln -s ~/ckan/etc /etc/ckan

# setup the env
sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

# install ckan
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.4.3#egg=ckan'
# install dependencies
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt

# to make sure the virtualenv's copies of the commands, like paster,
# are used rather than system-wide install copies
deactivate
. /usr/lib/ckan/default/bin/activate

# db location
initdb -D /usr/lib/ckan/default/data
# start db
pg_ctl -D /usr/lib/ckan/default/data -l /apps/logs/db/db.log start

## Install extensions
pip install -e 'git+https://github.com/ckan/ckanext-pdfview#egg=ckanext-pdfview'
pip install -e 'git+https://github.com/ckan/ckanext-geoview#egg=ckanext-geoview'
pip install -e 'git+https://github.com/ckan/ckanext-repo.git#egg=ckanext-repo'
pip install -e 'git+https://github.com/ckan/ckanext-apihelper.git#egg=ckanext-apihelper'
pip install -e 'git+https://github.com/ckan/ckanext-googleanalytics.git#egg=ckanext-googleanalytics'
pip install -e 'git+https://github.com/datagovuk/ckanext-ga-report.git#egg=ckanext-ga-report'
pip install -r /usr/lib/ckan/default/src/ckanext-ga-report/requirements.txt
pip install -e 'git+https://github.com/ckan/datapusher.git@0.0.8#egg=datapusher'
pip install -r /usr/lib/ckan/default/src/datapusher/requirements.txt

## Solr setup
# backup solr schema
mv /apps/solr/example/solr/collection1/conf/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml.bak
# link schema from ckan to solr
ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml
# for repoze, needs to be in the same directory as the .ini file
ln -s /usr/lib/ckan/default/src/ckan/who.ini /apps/ckan/conf/who.ini
# start solr
# double check on the host machine in a web browser to connect to the solr home: http://localhost:8984/solr
/apps/solr/bin/solr start


# Enter the password "pass" for both users
createuser -S -D -R -P -l ckan_default

createuser -S -D -R -P -l datastore_default

# Assign DB to users
createdb -O ckan_default ckan_default -E utf-8
createdb -O ckan_default datastore_default -E utf-8

# initialize the db
paster --plugin=ckan db init -c /apps/ckan/conf/development.ini
# setting db permissions for datastore
paster --plugin=ckan datastore set-permissions -c /apps/ckan/conf/development.ini | psql ckan_default --set ON_ERROR_STOP=1

# start datapusher
datapusher /apps/ckan/conf/datapusher_settings.py &
# start ckan
# open up ckan in your web browser: http://127.0.0.1:5050/, the ckan index page should appear
paster --plugin=ckan serve /apps/ckan/conf/development.ini
