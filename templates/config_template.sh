##
## Project Configuration
##
## Note: once installed, if you want to make any changes, you will need
## to edit both this file and $SERVER_SETTINGS_DIR/settings_local.py.
##

if [[ -z "$BASH" ]]; then
	echo "Error: this script expects to be sourced from the BASH shell"
	exit 1
fi

# Name of project (used by nginx, gunicorn, ...)
# Can only contain: lowercase text and numbers and underscores, and the first
# character must be a letter.
#
# NOTE: If you want to change this after installation, you will need to find
# all system components that use this variable and update them.  It's probably
# easier to just reinstall with a new PROJECT_NAME.
PROJECT_NAME=

# Server name: public hostname of this machine.  Leave as 'localhost' if you
# are only running locally.
#    Correct: localhost or example.com or subdomain.example.com
#    Incorrect: www.example.com or http://www.example.com
# Note: after installation, you need to also edit:
#     $SERVER_SETTINGS_DIR/settings_local.py
SERVER_NAME=localhost

# Server IP address.  Leave as 127.0.0.1 if you are only running locally.
# Note: after installation, you need to also edit:
#     $SERVER_SETTINGS_DIR/settings_local.py
SERVER_IP=127.0.0.1

# User/group for running the webserver.  The default of 'www-data' should be
# fine for Ubuntu.  This should be a special user separate from you or root.
# It should also match the user in /etc/nginx.conf.
SERVER_USER=www-data
SERVER_GROUP=www-data

# Your name and email -- you will get emailed with a stack trace on server
# failure, so it's a good idea to fill this in properly.
# Note: after installation, you need to also edit:
#     $SERVER_SETTINGS_DIR/settings_local.py
ADMIN_NAME="Admin Name"
ADMIN_EMAIL=admin@example.com

# Local time zone (important to get times correct)
# Note: after installation, you need to also edit:
#     $SERVER_SETTINGS_DIR/settings_local.py
# List of possible time zones:
#     http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TIME_ZONE=America/New_York

# Location of django-scripts (automatically found based on location of config.sh)
SCRIPTS_DIR="$(readlink -f "$( builtin cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )")"

# Root directory of this repository.  This assumes that the scripts folder is
# one level deep in the repository.
REPO_DIR="$(readlink -f "$( builtin cd "$SCRIPTS_DIR/.." && pwd )")"

# Django source files.
SRC_DIR=$REPO_DIR/server

# Django project module, settings, WSGI script
DJANGO_PROJECT_MODULE=$PROJECT_NAME
DJANGO_SETTINGS_MODULE=${DJANGO_PROJECT_MODULE}.settings
DJANGO_WSGI=${DJANGO_PROJECT_MODULE}.wsgi

# Django directory containing settings.py
SRC_SETTINGS_DIR=$SRC_DIR/$DJANGO_PROJECT_MODULE

# Virtualenv directory.
VENV_DIR=$REPO_DIR/venv

# External library directory.
OPT_DIR=$REPO_DIR/opt

# Location where local data is stored: (does not have to be inside the repository)
#   $DATA_DIR/static: static assets such as js, css, and copies of the paper.
#   $DATA_DIR/media: any locally saved images (currently everything is on S3)
DATA_DIR=$REPO_DIR/data

# Location where backups of the database are stored (does not have to be inside
# the repository).
BACKUP_DIR=$REPO_DIR/backup

# Location where Sphinx docs are stored (if any)
DOCS_DIR=$REPO_DIR/docs

# Directory holding run files (server logs, etc)
RUN_DIR=$REPO_DIR/run

# This file contains the most recent backup, and is is the version restored by
# ./restore_database.sh.
PSQL_DUMP_FILE=$BACKUP_DIR/pg_dump.sql.gz

# Online URL where the SQL 'pg_dump' file may be found
PSQL_DUMP_URL=

# PostgreSQL version.  Note that your database/cluster is tied to this version
# number, so don't change it unless you understand what's going on.
PSQL_VERSION=9.3

# PostgreSQL cluster, database, and user name -- cannot be changed after
# you make the first backup.
DB_CLUSTER=$PROJECT_NAME
DB_NAME=$PROJECT_NAME
DB_USER=$PROJECT_NAME

# Memcached: in-memory cache
MEMCACHED_HOST=127.0.0.1
MEMCACHED_PORT=11211

######

# Optional -- custom location of database cluster on disk -- if you have a
# fast secondary drive, or you have a small boot volume and large EBS disk,
# this to a dir in the empty volume.  If empty, this uses the Ubuntu default.
DB_DIR=

# Optional -- location of a second 'bare' repository which the server uses as
# its code base
REPO_BARE_DIR=


######

# Locations of templates to be filled in by install scripts
TEMPLATES_DIR=$SCRIPTS_DIR/templates
NGINX_TEMPLATE=$TEMPLATES_DIR/nginx_template.conf
DJANGO_SETTINGS_LOCAL_TEMPLATE=$TEMPLATES_DIR/django_settings_local_template.py
SUPERVISOR_TEMPLATE=$TEMPLATES_DIR/supervisor_template.conf
LOGROTATE_TEMPLATE=$TEMPLATES_DIR/logrotate_template.conf


######

# Advanced kernel parameters
# (see http://www.postgresql.org/docs/9.1/static/kernel-resources.html
# for more info on these parameters)

# Total amount of memory used by database for caching data.
# (this value gets put in the shared_buffers variable of
# /etc/postgresql/$PSQL_VERSION/$DB_DLUSTER/postgresql.conf)
PSQL_SHARED_BUFFERS=512MB

# Maximum size of shared memory segment in the linux kernel (bytes)
# (this value gets put in the kernel.shmmax variable of /etc/sysctl.conf)
KERNEL_SHMMAX=$(free -b | grep Mem | awk '{print $2}')  # total amount of RAM

# Total amount of shared memory available in the linux kernel (bytes or pages)
# (this value gets put in the kernel.shmall variable of /etc/sysctl.conf)
KERNEL_SHMALL=4294967296  # 16 TB in units of pages
