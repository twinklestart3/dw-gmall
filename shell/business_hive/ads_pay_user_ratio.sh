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
insert into table ads_pay_user_ratio
select
	t1.dt,pay_count,new_mid_count,pay_count/new_mid_count*100
from
(
	select '$do_date' dt,sum(pay_count) pay_count
	from ads_pay_user_count where dt<='$do_date'
) t1
join
(
	select '$do_date' dt,sum(new_mid_count) new_mid_count
	from ads_new_mid_count where create_date<='$do_date'
) t2
on t1.dt=t2.dt
"
    
$hive -e "$sql"