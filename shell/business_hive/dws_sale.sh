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
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_sale_detail_daycount partition(dt='$do_date')
select
	t1.user_id,t1.sku_id,
	t2.gender,months_between('$do_date',t2.birthday)/12 age,t2.user_level,
	t3.price,t3.sku_name,t3.tm_id,t3.category3_id,t3.category2_id,
    t3.category1_id,t3.category3_name,t3.category2_name,t3.category1_name,
    t3.spu_id,t1.sku_num,t1.order_count,t1.order_amount
from
(
	select
		user_id,sku_id,sum(sku_num) sku_num,count(*) order_count,
		sum(sku_num*order_price) order_amount
	from dwd_order_detail where dt='$do_date'
	group by user_id,sku_id
) t1
left join
(
	select
		id,name,birthday,gender,user_level
	from dwd_user_info where dt='$do_date'
) t2
on t1.user_id=t2.id
left join
(
	select
		id,spu_id,price,sku_name,tm_id,category3_id,category3_name,
		category2_id,category2_name,category1_id,category1_name
	from dwd_sku_info where dt='$do_date'
) t3
on t1.sku_id=t3.id;
"
    
$hive -e "$sql"