# Scripting-Database-backup
Shell script to backup databases: MYSQL & PostgreSQL

The 2 scripts are used to backup/dump databases to a directory called backup. So, first create a directory called backup.
Add the secrets or environment variables for the database. This can be done in the .bashrc file as below:                                                                             
    export DB_HOST="<enter db  host>"
    export DB_USERNAME="<enter db username>"
    export DB_PASSWORD="<db password>"

    
Run the script with the database name you want to backup e.g ./mysql.sh testdb or ./psql.sh testdb
You can also run the script: sudo sh mysql.sh testdb

Once the script is run, go to the backup directory and there should be a folder with the date of the backup e.g. 14Aug2023
In the date directory (14Aug2023), the database dumps are there, a zipped file and a .sql file.

When working in a team, different members may want to access this database files. If this script is run in a server you can use tools like FileZilla to retrieve them. Alternatively you can dump the files to an s3 bucket provided aws cli is installed. You can use the following command:                                                                                    
  aws s3 cp testdb-14Aug2023.sql.gz s3://<s3 bucket name>/
