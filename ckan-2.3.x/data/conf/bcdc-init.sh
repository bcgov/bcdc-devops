#!export/bin/sh
#author: leo.lou@gov.bc.ca
#edited: Jan 14/2016 Highway Three Solutions (Jared Smith/Karen Fishwick)
#edited: Jan 19/2016 H3 (Karen)  added hierarchy and moved extensions to /vagrant/ext/src because it is shared with host


## CKAN 
virtualenv /usr/local/ckan/default
source /usr/local/ckan/default/bin/activate
export JAVA_HOME=/usr/java/latest
export PATH=$JAVA_HOME/bin:$PATH:/usr/pgsql-9.1/bin
export LD_LIBRARY_PATH==$JAVA_HOME/lib:$LD_LIBRARY_PATH:/usr/pgsql-9.1/lib

mkdir -p  ~/bcdcsrc/src 
/usr/bin/wget -O ~/bcdcsrc/ckancoreq.txt https://raw.githubusercontent.com/ckan/ckan/ckan-2.3.1/requirements.txt
/usr/bin/wget -O ~/bcdcsrc/dpreq.text https://raw.githubusercontent.com/bcgov/datapusher/master/requirements.txt

cd ~/bcdcsrc/src
git clone https://github.com/bcgov/ckanext-bcgov.git
git clone https://github.com/bcgov/ckanext-ga-report.git
git clone https://github.com/bcgov/ckanext-geoview.git
git clone https://github.com/bcgov/ckanext-googleanalytics.git
git clone https://github.com/bcgov/ckanext-hierarchy.git
git clone https://github.com/bcgov/datapusher.git

svn co http://apps.bcgov/svn/edc/source/trunk/edc-ext/edc-rss

pip install ckan==2.3.3
pip install ckanext-pdfview==0.0.5
pip install pysqlite==2.8.1
pip install -r ~/bcdcsrc/ckancoreq.txt
for i in `ls -lrt -d -1 ~/bcdcsrc/src/* | awk '{print " " $9}'`; do cd $i; python setup.py develop; cd ..; done
for i in `ls -lrt -d -1 ~/bcdcsrc/src/* | awk '{print " " $9}'`; do pip install -e $i; done
pip install -r ~/bcdcsrc/dpreq.text

initdb -D /usr/local/ckan/default/data
pg_ctl -D /usr/local/ckan/default/data start
deactivate

source /usr/local/ckan/default/bin/activate
export PATH=$JAVA_HOME/bin:$PATH:/usr/pgsql-9.1/bin
export LD_LIBRARY_PATH==$JAVA_HOME/lib:$LD_LIBRARY_PATH:/usr/pgsql-9.1/lib

# Copy and modify the datapusher_settings.py 
mkdir /apps/datapusher
cp ~/bcdcsrc/src/datapusher/deployment/datapusher_settings.py  /apps/datapusher

# Edit the file /apps/datapusher/datapusher_settings.py and modify the line as follows:
## SQLALCHEMY_DATABASE_URI = 'postgresql://ckan_dlv:pass@localhost/ckan_dlv'


ln -s /usr/local/ckan/default/lib/python2.7/site-packages/ckan/config/who.ini /apps/ckan/conf/who.ini
mv /apps/solr/example/solr/collection1/conf/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml.bak
ln -s /usr/local/ckan/default/lib/python2.7/site-packages/ckan/config/solr/schema.xml /apps/solr/example/solr/collection1/conf/schema.xml
/apps/solr/bin/solr start
# double check on the host machine in a web browser to connect to the solr home: http://localhost:8983/solr

# Run manually (enter the password "pass" for the users to match the dlv ini
createuser -S -D -R  ckan 
createuser -S -D -R -P ckan_dlv
# Enter n for "Shall the new role be a superuser? (y/n)"
createuser -D -R -P datastore_dlv

createdb -O ckan_dlv ckan_dlv -E utf-8
createdb -O ckan_dlv datastore_dlv -E utf-8

# Note, you can ignore this message on the ckan import WARNING: errors ignored on restore: 1599
# Other warnings/errors (database already exists, checkpoints occuring to frequently) can also be ignored.G
pg_restore -Cd ckan_dlv /tmp/ckan.20160112.pgdump
pg_restore -Cd datastore_dlv /tmp/datastore.20160112.pgdump

mkdir -p /apps/logs/ckan_dlv
touch /apps/logs/ckan_dlv/dlv.log

paster --plugin=ckan search-index rebuild -c /apps/ckan/conf/dlv.ini
# this will take some time


nohup python ~/bcdcsrc/src/datapusher/datapusher/main.py /apps/datapusher/datapusher_settings.py &

paster serve /apps/ckan/conf/dlv.ini
# if all goes well, you should be able to see the bcgov site on your host's web browser http://localhost:5000


