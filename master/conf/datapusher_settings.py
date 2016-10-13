import uuid

DEBUG = False
TESTING = False
SECRET_KEY = str(uuid.uuid4())
USERNAME = str(uuid.uuid4())
PASSWORD = str(uuid.uuid4())

NAME = 'datapusher'

# database
SQLALCHEMY_DATABASE_URI = 'postgres://ckan_default:pass@localhost/datastore_default'

# webserver host and port
HOST = '0.0.0.0'
PORT = 8800

# logging

#FROM_EMAIL = 'server-error@example.com'
#ADMINS = ['yourname@example.com']  # where to send emails

LOG_FILE = '/apps/logs/ckan/datapusher.log'
#STDERR = True
