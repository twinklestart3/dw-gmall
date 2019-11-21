#!/bin/bash

if [[ $# != 2 ]]; then
    echo "请输入开始日期和结束日期"
    exit
fi

start=$1
end=$2

while [[ $start != $end ]]; do
    echo ========== $start ==========

    # 从ods_start_log获取数据插入到dwd_start_log中
    echo ========== $start =========="dwd_start_log"
    ./dwd_start_log.sh $start

    # 从ods_event_log获取数据插入到dwd_base_event_log中
    echo ========== $start =========="dwd_base_log"
    ./dwd_base_log.sh $start

    # 从dwd_base_event_log获取数据(display)插入到dwd_display_log中
    echo ========== $start =========="dwd_display_log"
    ./dwd_display_log.sh $start

    # 从dwd_base_event_log获取数据(newsdetail)插入到dwd_newsdetail_log中
    echo ========== $start =========="dwd_newsdetail_log"
    ./dwd_newsdetail_log.sh $start

    # 从dwd_base_event_log获取数据(loading)插入到dwd_loading_log中
    echo ========== $start =========="dwd_loading_log"
    ./dwd_loading_log.sh $start

    # 从dwd_base_event_log获取数据(ad)插入到dwd_ad_log中
    echo ========== $start =========="dwd_ad_log"
    ./dwd_ad_log.sh $start

    # 从dwd_base_event_log获取数据(notification)插入到dwd_notification_log中
    echo ========== $start =========="dwd_notification_log"
    ./dwd_notification_log.sh $start

    # 从dwd_base_event_log获取数据(active_foreground)插入到dwd_active_foreground_log中
    echo ========== $start =========="dwd_active_foreground_log"
    ./dwd_active_foreground_log.sh $start

    # 从dwd_base_event_log获取数据(active_background)插入到dwd_active_background_log中
    echo ========== $start =========="dwd_active_background_log"
    ./dwd_active_background_log.sh $start

    # 从dwd_base_event_log获取数据(comment)插入到dwd_comment_log中
    echo ========== $start =========="dwd_comment_log"
    ./dwd_comment_log.sh $start

    # 从dwd_base_event_log获取数据(favorites)插入到dwd_favorites_log中
    echo ========== $start =========="dwd_favorites_log"
    ./dwd_favorites_log.sh $start

    # 从dwd_base_event_log获取数据(praise)插入到dwd_praise_log中
    echo ========== $start =========="dwd_praise_log"
    ./dwd_praise_log.sh $start

    # 从dwd_base_event_log获取数据(error)插入到dwd_error_log中
    echo ========== $start =========="dwd_error_log"
    ./dwd_error_log.sh $start

    start=`date -d "$start +1 day" +%F`

done

