#!/bin/sh
#author: Highway Three Solutions (Jared Smith/Karen Fishwick)

## Installing CKAN

# Adjusting path environments
echo 'export JAVA_HOME=/usr/java/latest' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH:/usr/pgsql-9.1/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$JAVA_HOME/lib:/usr/pgsql-9.1/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

sudo chown -R `whoami`:`whoami` /apps
mkdir /apps/ckan/upload
# log location for ckan
mkdir -p /apps/logs/{ckan,db}

# allows ckan to be in the user's home directory
# while still being able to use copy-paste example commands
sudo chown -R `whoami`:`whoami` ~/ckan
mkdir -p ~/ckan/{etc,lib,src}
sudo ln -s ~/ckan/lib /usr/lib/ckan
sudo ln -s ~/ckan/etc /etc/ckan

# setup the env
sudo chown `whoami`:`whoami` /usr/lib/ckan
mkdir -p /usr/lib/ckan/ckan_env
sudo chown `whoami`:`whoami` ~/ckan/etc

virtualenv /usr/lib/ckan/ckan_env
source /usr/lib/ckan/ckan_env/bin/activate

cd ~/ckan/src

git clone https://github.com/ckan/ckan.git
git clone https://github.com/ckan/ckanext-pdfview.git
git clone https://github.com/ckan/ckanext-geoview.git
git clone https://github.com/ckan/ckanext-repo.git
git clone https://github.com/ckan/ckanext-apihelper.git
git clone https://github.com/ckan/datapusher.git

find ~/ckan/src -maxdepth 1 -mindepth 1 -type d -exec pip install -e {} \;

# install dependencies
pip install -r ~/ckan/src/datapusher/requirements.txt
pip install -r ~/ckan/src/ckan/requirements.txt
pip install -r ~/ckan/src/ckan/dev-requirements.txt

# db location
initdb -D /usr/lib/ckan/data
# start db
pg_ctl -D /usr/lib/ckan/data -l /apps/logs/db/db.log start

until [ -S /tmp/.s.PGSQL.5432 ] ; do
 /bin/echo "Waiting for PostgreSQL to start..."
 /bin/sleep 1
done

psql -wd postgres -c "create user ckan_default with password 'pass'"
psql -wd postgres -c "create user datastore_default with password 'pass'"

# Assign DB to users
createdb -O ckan_default ckan_default -E utf-8
createdb -O ckan_default datastore_default -E utf-8
# test DB
createdb -O ckan_default ckan_test -E utf-8
createdb -O ckan_default datastore_test -E utf-8

## Solr setup
# backup solr schema
mv /apps/solr/example/solr/collection1/conf/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml.bak
# link schema from ckan to solr
ln -s /home/vagrant/ckan/src/ckan/ckan/config/solr/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml
# for repoze, needs to be in the same directory as the .ini file
ln -s /home/vagrant/ckan/src/ckan/who.ini /apps/ckan/conf/who.ini
# start solr
# double check on the host machine in a web browser to connect to the solr home: http://localhost:8984/solr
/apps/solr/bin/solr start

# initialize the db
paster --plugin=ckan db init -c /apps/ckan/conf/development.ini
# setting db permissions for datastore
paster --plugin=ckan datastore set-permissions -c /apps/ckan/conf/development.ini | psql ckan_default --set ON_ERROR_STOP=1

echo ""
echo "Ckan has been installed and is ready to run."
# start datapusher
#datapusher /apps/ckan/conf/datapusher_settings.py &
# start ckan
# open up ckan in your web browser: http://10.1.0.3:5000/, the ckan index page should appear
#paster --plugin=ckan serve /apps/ckan/conf/development.ini
