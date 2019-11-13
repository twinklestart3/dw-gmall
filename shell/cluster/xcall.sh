#!/bin/bash

if [[ -n $1 ]]; then
    cmd=$@
else
    cmd=jps
fi

for host in hadoop222 hadoop223 hadoop224 ; do
    echo ========= $host =========
    ssh $host "source /etc/profile ; $cmd"
done
