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
insert into table ads_user_convert_day
select '$do_date',sum(uv_m_count),sum(new_m_count),sum(new_m_count)/sum(uv_m_count)*100 from
(
	select day_count uv_m_count,0 new_m_count
	from ads_uv_count where dt='$do_date'
	union all
	select 0 uv_m_count,new_mid_count new_mid_count
	from ads_new_mid_count where create_date='$do_date'
) t;
"
    
$hive -e "$sql"