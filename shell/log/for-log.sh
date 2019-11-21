#!/bin/bash

flume_home=/opt/module/flume-1.7.0

if [[ $# != 2 ]]; then
    echo "请输入开始日期和结束日期"
    exit
fi

start=$1
end=$2


    ssh hadoop224 "source /etc/profile ; nohup $flume_home/bin/flume-ng agent -n a1 -c $flume_home/conf -f /opt/dw0722/flume/kafka2hdfs.conf >/dev/null 2>&1 &"

    ssh hadoop222 "source /etc/profile ; nohup $flume_home/bin/flume-ng agent -n a1 -c $flume_home/conf/ -f /opt/dw0722/flume/filelog2kafka.conf >/dev/null 2>&1 &"

    ssh hadoop223 "source /etc/profile ; nohup $flume_home/bin/flume-ng agent -n a1 -c $flume_home/conf/ -f /opt/dw0722/flume/filelog2kafka.conf >/dev/null 2>&1 &"


while [[ $start != $end ]]; do
    for host in hadoop222 hadoop223 hadoop224 ; do
        echo ========== $host:设置时间 ==========
        ssh -t $host "source /etc/profile ; sudo date -s \"$start\""
    done



    ssh hadoop222 "source /etc/profile ; nohup java -jar /opt/dw0722/data-producer/data-producer-1.0-SNAPSHOT-jar-with-dependencies.jar >/dev/null 2>&1 &"

    ssh hadoop223 "source /etc/profile ; nohup java -jar /opt/dw0722/data-producer/data-producer-1.0-SNAPSHOT-jar-with-dependencies.jar >/dev/null 2>&1 &"

    sleep 120



    start=`date -d "1 day" +%F`
done


    ssh hadoop222 "source /etc/profile ; ps -ef | awk '/filelog2kafka.conf/ && !/awk/{print \$2}' | xargs kill -9"

    ssh hadoop223 "source /etc/profile ; ps -ef | awk '/filelog2kafka.conf/ && !/awk/{print \$2}' | xargs kill -9"

    ssh hadoop224 "source /etc/profile ; ps -ef | awk '/kafka2hdfs.conf/ && !/awk/ {print \$2}' | xargs kill -9"

for host in hadoop222 hadoop223 hadoop224 ; do
        echo ========== $host:还原时间 ==========
        ssh -t $host "source /etc/profile ; sudo ntpdate ntp1.aliyun.com"
done




