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
insert into table $APP.ads_gmv_sum_day
select
	'$do_date' dt,sum(order_count),sum(order_amount),sum(payment_amount)
from $APP.dws_user_action where dt='$do_date' group by dt;
"
    
$hive -e "$sql"