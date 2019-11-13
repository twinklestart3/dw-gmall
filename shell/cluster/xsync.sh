#!/bin/bash

if [[ $# == 0 ]]; then
    echo '请输入要分发的文件或路径'
    exit
fi

# 文件名
fileName=`basename $1`

# 绝对路径
dir=`cd -P $(dirname $1);pwd`

# 当前用户名
user=`whoami`

for host in hadoop222 hadoop223 hadoop224 ; do
    echo ========== $host ==========
    rsync -rvl $dir/$fileName $user@$host:$dir
done