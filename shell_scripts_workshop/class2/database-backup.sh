#!/bin/bash

Fdate=`date +%y-%m-%d`
MyUSER="root"     # USERNAME
MyPASS="root"       # PASSWORD
MyHOST="localhost"          # Hostname
# Linux bin paths, change this if it can't be autodetected via which command
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
CHOWN="/bin/chown"
CHMOD="/bin/chmod"
GZIP="/bin/gzip"
# Backup Dest directory, change this if you have someother location
DEST="/home/fcoos/dbbackup/"
# Main directory where backup will be stored
MBD="$DEST/$Fdate"
# Store list of databases
DBS=""
[ ! -d $MBD ] && mkdir -p $MBD || :
# Only root can access it!
$CHOWN 0.0 -R $DEST
$CHMOD 0600 $DEST
# Get all database list first

DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"
for db in $DBS
do

$MYSQLDUMP --skip-lock-tables -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > /$MBD/$db-$Fdate.gz
done
tbsize=$(du -csh $MBD | grep total | awk '{print $1}')
echo "########################################################################" > /$DEST/mail-body.txt
echo "Db3.fcoos.com Server Mysql Backup has been completed successfully and details given below:" >> /$DEST/mail-body.txt
echo "Backup Path:$MBD:" >> /$DEST/mail-body.txt
echo "Backup Size:$tbsize"  >> /$DEST/mail-body.txt
echo "Mysql backup file size and thier names are as below:" >> /$DEST/mail-body.txt
echo "########################################################################" >> /$DEST/mail-body.txt
echo >> /$DEST/mail-body.txt
cd $MBD; 
du -csh * >> /$DEST/mail-body.txt
cat /$DEST/mail-body.txt | mail -s "fcoos db Server Mysql Backup Completed on fcoos mail Server for `date +%d%b%Y` Backup size: $tbsize" jsenthilnathanlinux@gmail.com -- -f admin@fcoos.com


