#!/bin/bash

APP=gmall
hive=/opt/module/hive-1.2.1/bin/hive

if [[ -n $1 ]]; then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi
    
sql="
use gmall;
insert into table ads_new_mid_count
select
	create_date,count(*)
from dws_new_mid_day
where create_date='$do_date'
group by create_date;
"
    
$hive -e "$sql"