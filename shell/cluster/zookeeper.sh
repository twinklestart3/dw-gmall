#!/bin/bash

zookeeper_home=/opt/module/zookeeper-3.4.10
case $1 in
    start | stop | status)
        for host in hadoop222 hadoop223 hadoop224 ; do
            echo ========== $host ==========
            ssh $host "source /etc/profile ; $zookeeper_home/bin/zkServer.sh $1"
        done
    ;;
    *)
        echo "你启动的姿势不对"
        echo "  start   启动zookeeper集群"
        echo "  stop    停止zookeeper集群"
        echo "  status  查看zookeeper集群"
    ;;
esac


