#!/bin/bash
# Script to backup hive metadata database

mysqldump --single-transaction --skip-opt --skip-extended-insert --add-drop-table --routines --triggers --events --log-error=/dbbackup/mysql/hive/rctq_hive_mysqldb_backup.log --databases hive | gzip > /dbbackup/mysql/hive/rctq_hive_mysqldb_backup_`/bin/date +\%Y\%m\%d`.gz;


# Modified - Remove backups older than 1 day - Testing
find /dbbackup/mysql/hive -maxdepth 1 -type d -mtime +1 -exec rm -rf {} \;

# Checking if the backup is genuine or not

cp  -R /dbbackup/mysql/hive/rctq_hive_mysqldb_backup_`/bin/date +\%Y\%m\%d`.gz  /dbbackup/mysql/hive/rctq_hive_mysqldb_backup1_`/bin/date +\%Y\%m\%d`.gz;

#gunzip -f /dbbackup/mysql/hive/rctq_hive_mysqldb_backup1_`/bin/date +\%Y\%m\%d`.gz;

if [  "$(grep -i 'Dump completed' gzip  /dbbackup/mysql/hive/rctq_hive_mysqldb_backup1_`/bin/date +\%Y\%m\%d`.gz)" ];

then
echo "SUCCESS: Hive Daily backup completed." | mail -s "SUCCESS backup completed" -r "DoNotReply" venkat.velagala@infor.com


else

echo "FAILURE: Hive backup failed."  | mail -s "FAILURE backup failed" -r "DoNotReply" venkat.velagala@infor.com

fi

