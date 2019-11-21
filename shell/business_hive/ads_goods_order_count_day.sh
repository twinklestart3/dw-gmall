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
insert into table ads_goods_order_count_day
select
	'$do_date' dt,
	sku_id,
	sum(order_count) order_total_count
from dws_sale_detail_daycount where dt='$do_date'
group by sku_id order by order_total_count desc limit 10;
"
    
$hive -e "$sql"