#!/bin/bash
set -eux

exec 1>${HOME}/jvm-monitoring.log
exec 2>&1

jcmd > /tmp/foo
declare pid=""
while read pidline ; do
     flag=`echo $pidline|awk '{print match($0,"spring")}'`;
      if [ $flag -gt 0 ];then
           pidinfo=(${pidline/ / })
           pid=${pidinfo[0]}
      fi
done < /tmp/foo
jstat -class $pid 100ms &
jstat -gccause -h20 -t $pid 100ms &>out.log &
