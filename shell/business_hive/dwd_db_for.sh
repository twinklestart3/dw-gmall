#!/bin/bash


if [[ $# != 2 ]]; then
    echo "请输入开始日期和结束日期"
    exit
fi

start=$1
end=$2

while [[ $start != $end ]]; do
    echo ========== $start ==========

    ./dwd_db.sh $start

    start=`date -d "$start 1 day" +%F`
done