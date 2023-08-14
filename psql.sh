#!/bin/bash
##
################################################################

echo "Initialize and setup environment variables"
set -e
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

################################################################
################## Update below values **** ########################

echo "Read database credentials from the environment variables and CLI command"
DB_BACKUP_PATH='backup'
PSQL_HOST=""
PSQL_PORT="5432"
PSQL_USER=""
PSQL_PASSWORD=""
DATABASE_NAME="$1"
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy

#################################################################
echo "Create backup directory"
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
rm -rf ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}*

echo "Backup using PSQL Dump commmand"
PGPASSWORD=${PSQL_PASSWORD} pg_dump --format=c --username=${PSQL_USER} --dbname=${DATABASE_NAME} --host=${PSQL_HOST} | gzip >  ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz
 
 ##########################################################################
echo "Unzipp the gz file"
cd ${DB_BACKUP_PATH}/${TODAY}; gunzip -k  ${DATABASE_NAME}-${TODAY}.sql.gz
sed -i '1s/^/drop database if exists `'"${DATABASE_NAME}"'`;\ncreate database `'"${DATABASE_NAME}"'`;\nuse `'"${DATABASE_NAME}"'`;\n/' ${DATABASE_NAME}-${TODAY}.sql
cd -
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi      
