#!/bin/bash

host_loki="http://172.31.24.210:3100/loki/api/v1/push"
label="label_portal"
label_name="monitor-netcat-db"

for ((i=0; ;i++ ))
do 
  succeed="$(nc -vv -z hostdb.rds.com 3306 2>&1 | sed 's/^Connection.*succeeded\!$/success/g')"
  	if [[ $succeed != "success" ]]
	then
		curl -v -H "Content-Type: application/json" -X POST -s $host_loki -d '{"streams": [{ "stream": { "'$label'": "'$label_name'" }, "values": [ [ "'$(date +%s%N)'", "connection to database FAILED" ] ] }]}'
	else
		curl -v -H "Content-Type: application/json" -X POST -s $host_loki -d '{"streams": [{ "stream": { "'$label'": "'$label_name'" }, "values": [ [ "'$(date +%s%N)'", "connection to database SUCCESS" ] ] }]}'
  	fi
sleep 2
done
