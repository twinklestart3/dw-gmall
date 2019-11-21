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
insert into table ads_user_action_convert_day
select
	'$do_date',
	uv.day_count,
	ua.order_count,
	cast(ua.order_count / uv.day_count as decimal(10,2)),
	ua.payment_count,
	cast(ua.payment_count / ua.order_count as decimal(10,2))
from
(
	select
		dt,
		sum(if(order_count>0,1,0)) order_count,
		sum(if(payment_count>0,1,0)) payment_count
	from dws_user_action where dt='$do_date' group by dt
) ua
join ads_uv_count uv on ua.dt=uv.dt;
"
    
$hive -e "$sql"