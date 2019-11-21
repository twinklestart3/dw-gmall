#!/bin/bash

APP=gmall
hive=/opt/module/hive-1.2.1/bin/hive
hadoop=/opt/module/hadoop-2.7.2/bin/hadoop


case $# in
    0)
        ./ods_log.sh
    ;;
    1)
        ./ods_log.sh $1
    ;;
    2)
        start=$1
        end=$2
        while [[ $start != $end ]]; do
            # hadoop fs -test -e /origin_data/gmall/log/topic_start/2019-11-10 参在则$?为0
            hadoop fs -test -e /origin_data/gmall/log/topic_start/$start
            if [[ $? == 0 ]]; then
                file_count=`hadoop fs -count /origin_data/gmall/log/topic_start/$start | awk '{print \$2}'`
                if [[ file_count > 0 ]]; then
                    ./ods_log.sh $start
                fi
            fi
            # date -d '2019-11-11 +1 day' +%F
            start=`date -d "$start +1 day" +%F`

            sleep 10
        done
    ;;
    *)
        echo "参数个数错误"
        echo "0个参数：执行前一天数据"
        echo "1个参数：执行输入日期数据"
        echo "2个参数：执行开始日期到结束日期数据(不包含结束日期)"
        exit
    ;;
esac