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
insert overwrite table dwd_loading_log partition(dt='$do_date')
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
	get_json_object(event_json,'$.kv.action') action,
	get_json_object(event_json,'$.kv.loading_time') loading_time,
	get_json_object(event_json,'$.kv.loading_way') loading_way,
	get_json_object(event_json,'$.kv.extend1') extend1,
	get_json_object(event_json,'$.kv.extend2') extend2,
	get_json_object(event_json,'$.kv.type') type,
	get_json_object(event_json,'$.kv.type1') type1,
	server_time
from dwd_base_event_log
where event_name='loading' and dt='$do_date';
"
    
$hive -e "$sql"