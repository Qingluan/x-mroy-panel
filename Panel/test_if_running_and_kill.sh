#!/bin/bash

#  test_if_running.sh
#  Panel
#
#  Created by dr on 2019/3/18.
#  Copyright © 2019 dr. All rights reserved.

TMP="ps aux |egrep -v \"(grep|$0)\""
for i in $* ;do
if [[ ! $i == "-*" ]];then
TMP="$TMP | grep $i"
fi
done
TMP="$TMP | awk '{print \$2}' | xargs kill -9"
eval "$TMP";
if [ $? -eq 0 ];then
echo "Kill ok"
else
echo "kill failed"
fi

