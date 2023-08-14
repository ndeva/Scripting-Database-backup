#!/bin/bash
##
################################################################

set -e
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

################################################################
################## Update below values  ########################

DB_BACKUP_PATH='backup'
MYSQL_HOST=${DB_HOST}
MYSQL_PORT="3306"
MYSQL_USER=${DB_USERNAME}
MYSQL_PASSWORD=${DB_PASSWORD}
DATABASE_NAME="$1"
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy

#################################################################

mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
rm -rf ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}*
mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
    ${DATABASE_NAME} --set-gtid-purged=OFF --column-statistics=0 --ignore-table=${DATABASE_NAME}.e_event_error \
   | gzip >  ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz

cd ${DB_BACKUP_PATH}/${TODAY}; gunzip -k  ${DATABASE_NAME}-${TODAY}.sql.gz
sed -i '1s/^/drop database if exists `'"${DATABASE_NAME}"'`;\ncreate database `'"${DATABASE_NAME}"'`;\nuse `'"${DATABASE_NAME}"'`;\n/' ${DATABASE_NAME}-${TODAY}.sql
cd -
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
