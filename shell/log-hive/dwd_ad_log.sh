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
insert overwrite table dwd_ad_log partition(dt='$do_date')
select
	mid_id,
	user_id,
	version_code,
	version_name,
	lang,
	source,
	os,
	area,
	model,
	brand,
	sdk_version,
	gmail,
	height_width,
	app_time,
	network,
	lng,
	lat,
	get_json_object(event_json,'$.kv.entry') entry,
	get_json_object(event_json,'$.kv.action') action,
	get_json_object(event_json,'$.kv.content') content,
	get_json_object(event_json,'$.kv.detail') detail,
	get_json_object(event_json,'$.kv.source') ad_source,
	get_json_object(event_json,'$.kv.behavior') behavior,
	get_json_object(event_json,'$.kv.newstype') newstype,
	get_json_object(event_json,'$.kv.show_style') show_style,
	server_time
from dwd_base_event_log
where event_name='ad' and dt='$do_date';
"
    
$hive -e "$sql"