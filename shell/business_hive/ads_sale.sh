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
insert into table ads_sale_tm_category1_stat_mn
select
	sku_tm_id,sku_category1_id,sku_category1_name,
	sum(if(order_count>=1,1,0)) buycount,
    sum(if(order_count>=2,1,0)) buyTwiceLast,
    sum(if(order_count>=2,1,0))/sum( if(order_count>=1,1,0)) buyTwiceLastRatio,
    sum(if(order_count>=3,1,0))  buy3timeLast  ,
    sum(if(order_count>=3,1,0))/sum( if(order_count>=1,1,0)) buy3timeLastRatio ,
    date_format('2019-02-10' ,'yyyy-MM') stat_mn,
    '2019-02-10' stat_date
from
(
	select
		user_id,sku_tm_id,sku_category1_id,sku_category1_name,
		sum(order_count) order_count
	from dws_sale_detail_daycount
	where date_format(dt,'yyyy-MM')=date_format('$do_date','yyyy-MM')
	group by user_id,sku_tm_id,sku_category1_id,sku_category1_name
) t
group by sku_tm_id,sku_category1_id,sku_category1_name;
"
    
$hive -e "$sql"