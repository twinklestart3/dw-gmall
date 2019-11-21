#!/bin/bash

APP=gmall
hive=/opt/module/hive-1.2.1/bin/hive
hadoop=/opt/module/hadoop-2.7.2/bin/hadoop

if [[ -n $1 ]]; then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi
    
sql="
use gmall;
insert into table ads_user_retention_day_rate
select
	'$do_date',
	ur.create_date,
	ur.retention_day,
	ur.retention_count,
	nc.new_mid_count,
	ur.retention_count / nc.new_mid_count * 100
from ads_user_retention_day_count ur
join ads_new_mid_count nc
on ur.create_date=nc.create_date
where date_add(ur.create_date,ur.retention_day)='$do_date';
"
    
$hive -e "$sql"