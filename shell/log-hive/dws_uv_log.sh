#!/bin/bash

APP=gmall
hive=/opt/module/hive-1.2.1/bin/hive

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [[ -n $1 ]]; then
    do_date=$1
else
    do_date=`date -d "-1 day" +%F`
fi
    
sql="
use gmall;

set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table dws_uv_detail_day partition(dt='$do_date')
select
	dsl.mid_id,
	concat_ws('|',collect_set(dsl.user_id)) user_id,
	concat_ws('|', collect_set(version_code)) version_code,
    concat_ws('|', collect_set(version_name)) version_name,
    concat_ws('|', collect_set(lang))lang,
    concat_ws('|', collect_set(source)) source,
    concat_ws('|', collect_set(os)) os,
    concat_ws('|', collect_set(area)) area,
    concat_ws('|', collect_set(model)) model,
    concat_ws('|', collect_set(brand)) brand,
    concat_ws('|', collect_set(sdk_version)) sdk_version,
    concat_ws('|', collect_set(gmail)) gmail,
    concat_ws('|', collect_set(height_width)) height_width,
    concat_ws('|', collect_set(app_time)) app_time,
    concat_ws('|', collect_set(network)) network,
    concat_ws('|', collect_set(lng)) lng,
    concat_ws('|', collect_set(lat)) lat
from dwd_start_log as dsl
where dsl.dt='$do_date'
group by dsl.mid_id;


insert overwrite table dws_uv_detail_wk partition(wk_dt)--动态分区
select
	mid_id,
    concat_ws('|', collect_set(user_id)) user_id,
    concat_ws('|', collect_set(version_code)) version_code,
    concat_ws('|', collect_set(version_name)) version_name,
    concat_ws('|', collect_set(lang)) lang,
    concat_ws('|', collect_set(source)) source,
    concat_ws('|', collect_set(os)) os,
    concat_ws('|', collect_set(area)) area,
    concat_ws('|', collect_set(model)) model,
    concat_ws('|', collect_set(brand)) brand,
    concat_ws('|', collect_set(sdk_version)) sdk_version,
    concat_ws('|', collect_set(gmail)) gmail,
    concat_ws('|', collect_set(height_width)) height_width,
    concat_ws('|', collect_set(app_time)) app_time,
    concat_ws('|', collect_set(network)) network,
    concat_ws('|', collect_set(lng)) lng,
    concat_ws('|', collect_set(lat)) lat,
	date_add(next_day('$do_date','mo'),-7),
	date_add(next_day('$do_date','mo'),-1),
	--动态分区
	concat(date_add(next_day('$do_date','mo'),-7),'_',date_add(next_day('$do_date','mo'),-1))
from gmall.dws_uv_detail_day
where dt<=date_add(next_day('$do_date','mo'),-1)
and dt>=date_add(next_day('$do_date','mo'),-7)
group by mid_id;


insert overwrite table dws_uv_detail_mn partition(mn)
select
	mid_id,
    concat_ws('|', collect_set(user_id)) user_id,
    concat_ws('|', collect_set(version_code)) version_code,
    concat_ws('|', collect_set(version_name)) version_name,
    concat_ws('|', collect_set(lang)) lang,
    concat_ws('|', collect_set(source)) source,
    concat_ws('|', collect_set(os)) os,
    concat_ws('|', collect_set(area)) area,
    concat_ws('|', collect_set(model)) model,
    concat_ws('|', collect_set(brand)) brand,
    concat_ws('|', collect_set(sdk_version)) sdk_version,
    concat_ws('|', collect_set(gmail)) gmail,
    concat_ws('|', collect_set(height_width)) height_width,
    concat_ws('|', collect_set(app_time)) app_time,
    concat_ws('|', collect_set(network)) network,
    concat_ws('|', collect_set(lng)) lng,
    concat_ws('|', collect_set(lat)) lat,
	date_format('$do_date','yyyy-MM')
from dws_uv_detail_day
where date_format(dt,'yyyy-MM')=date_format('$do_date','yyyy-MM')
group by mid_id;
"
    
$hive -e "$sql"