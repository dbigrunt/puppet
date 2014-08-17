#!/bin/bash

SQLUSER="root"
SQLPASSWD=""
#MYSQLDUMP="mysqldump -u$SQLUSER -p$SQLPASSWD -a --opt --allow-keywords"
MYSQLDUMP="mysqldump -u$SQLUSER -a --opt --allow-keywords"
BZIP2=`which bzip2`
BACKUPDIR=$1
DATE=`date +%Y-%m-%d`

#for DATABASE in `mysql -u$SQLUSER -p$SQLPASSWD -s -N -e 'show databases'`
for DATABASE in `mysql -u$SQLUSER -s -N -e 'show databases' | grep -v information | grep -v test`
do
  echo "Dumping $DATABASE onto $BACKUPDIR":
  $MYSQLDUMP $DATABASE | $BZIP2 -c > $BACKUPDIR/$DATABASE-$DATE.sql.bz2 && echo done || echo something went wrong!
done

echo "Deleting SQL dumps older than 7 days:"
find $BACKUPDIR -type f -mtime +7 -exec rm -f {} \;  && echo done || echo something went wrong!

