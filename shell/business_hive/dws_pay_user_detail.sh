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
set hive.exec.dynamic.partition=nonstrict;
insert overwrite table dws_pay_user_detail partition(dt='$do_date')
select t1.user_id,t2.name,t2.birthday,t2.gender,t2.email,t2.user_level
from
(
	select user_id from dws_user_action
	where dt='$do_date' and payment_count>0
) t1
left join
(
	select * from dwd_user_info where dt='$do_date'
) t2
on t1.user_id = t2.id
left join dws_pay_user_detail t3
on t1.user_id=t3.user_id
where t3.user_id is null;
"
    
$hive -e "$sql"