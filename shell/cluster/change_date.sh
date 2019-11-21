#!/bin/bash

for host in hadoop222 hadoop223 hadoop224 ; do
    echo ========== $host ==========
    ssh -t $host "source /etc/profile ; sudo date -s $1"
done
