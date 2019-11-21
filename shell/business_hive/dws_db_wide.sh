#!/bin/bash

APP=gmall
hive=/opt/module/hive-1.2.1/bin/hive

if [[ -n $1 ]]; then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi
    
sql="
with
tmp_order as(
	select user_id,count(*) order_count,sum(total_amount) order_amount
	from $APP.dwd_order_info
	where date_format(create_time,'yyyy-MM-dd')='$do_date' group by user_id
),
tmp_payment as(
	select user_id,count(*) payment_count,sum(total_amount) payment_amount
	from $APP.dwd_payment_info
	where date_format(payment_time,'yyyy-MM-dd')='$do_date' group by user_id
),
tmp_comment as(
	select user_id,count(*) comment_count
	from $APP.dwd_comment_log
	where date_format(dt,'yyyy-MM-dd')='$do_date' group by user_id
)

insert overwrite table $APP.dws_user_action partition(dt='$do_date')
select user_id,sum(order_count),sum(order_amount),sum(payment_count),sum(payment_amount),sum(comment_count)
from(
	select user_id,order_count,order_amount,0 payment_count,0 payment_amount,0 comment_count from tmp_order
	union all
	select user_id,0 order_count,0 order_amount,payment_count,payment_amount,0 comment_count from tmp_payment
	union all
	select user_id,0 order_count,0 order_amount,0 payment_count,0 payment_amount,comment_count from tmp_comment
) t group by t.user_id;
"
    
$hive -e "$sql"