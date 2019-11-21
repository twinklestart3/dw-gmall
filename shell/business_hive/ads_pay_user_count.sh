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
insert into table ads_pay_user_count
select
	'$do_date',count(*)
from dws_pay_user_detail where dt='$do_date';
"
    
$hive -e "$sql"