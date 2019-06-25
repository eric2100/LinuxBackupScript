#!/bin/bash
workdir=/home/backup/
folder_file="/var/www/html;/etc;/home/eric/public_html"
# 資料庫名稱使用 分號隔開
db_file="database1;database2;database3"
SQL_USER="MariadbUser"
SQL_PASSWD="MariadbPassword"

# ??份輸出
filename=backup-$(date +%y%m%d).tgz

function createFolder {
arr=$(echo $folder_file | tr ";" "\n")

for d in $arr ; do
echo $d
	target_backup_file=$workdir/file${d//[\/]/_}_$filename
    tar zcfP $target_backup_file $d 
done
}

function createDb {
arr=$(echo $db_file | tr ";" "\n")

for d in $arr ; do
 if [ $d != "information_schema" ] ;
 then	
	 mysqldump --events --ignore-table=mysql.events -u $SQL_USER -p$SQL_PASSWD $d > $workdir/db_${d}_$(date +%y%m%d).sql
 fi
done

tar zcfP $workdir/db_alldata.$filename $workdir/*.sql 
rm -rf $workdir/*.sql 
}		
	
createFolder	
createDb
