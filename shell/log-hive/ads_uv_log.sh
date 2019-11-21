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
set hive.exec.dynamic.partition.mode=nonstrict;
insert into table ads_uv_count
select
	'$do_date' dt,
	daycount.day_count,
	wkcount.wk_count,
	mncount.mn_count,
	if(date_add(next_day('$do_date','mo'),-1)=='$do_date','Y','N'),
	if(last_day('$do_date')=='$do_date','Y','N')
from
(
	select '$do_date' dt,count(*) day_count from dws_uv_detail_day
	where dt='$do_date'
) daycount
join
(
	select '$do_date' dt,count(*) wk_count from dws_uv_detail_wk
	where wk_dt=concat(date_add(next_day('$do_date','mo'),-7),'_',date_add(next_day('$do_date','mo'),-1))
) wkcount on daycount.dt=wkcount.dt
join
(
	select '$do_date' dt,count(*) mn_count from dws_uv_detail_mn
	where mn=date_format('$do_date','yyyy-MM')
) mncount on daycount.dt=mncount.dt;
"
    
$hive -e "$sql"