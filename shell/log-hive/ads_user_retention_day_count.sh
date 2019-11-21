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
insert into table ads_user_retention_day_count
select
	create_date,
	retention_day,
	count(*)
from dws_user_retention_day
where dt='$do_date'
group by create_date,retention_day;
"
    
$hive -e "$sql"