#!/bin/bash

case $1 in
    start)
        echo ========== hadoop222 上启动hdfs ==========
        ssh hadoop222 "source /etc/profile ; start-dfs.sh"

        echo ========== hadoop223 上启动yarn ==========
        ssh hadoop223 "source /etc/profile ; start-yarn.sh"

        echo ========== hadoop223 上启动history ==========
        ssh hadoop222 "source /etc/profile ; mr-jobhistory-daemon.sh start historyserver"
    ;;
    stop)
        echo ========== hadoop223 上停止yarn ==========
        ssh hadoop223 "source /etc/profile ; stop-yarn.sh"

        echo ========== hadoop223 上停止history ==========
        ssh hadoop222 "source /etc/profile ; mr-jobhistory-daemon.sh stop historyserver"

        echo ========== hadoop222 上停止hdfs ==========
        ssh hadoop222 "source /etc/profile ; stop-dfs.sh"
    ;;
    *)
        echo "你启动的姿势不对"
        echo "  start 启动hadoop集群"
        echo "  stop  停止hadoop集群"
    ;;
esac