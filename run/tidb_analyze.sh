#!/bin/bash
host=127.0.0.1
port=4000
user=root
#password='-p123'
password=''
dbname=tpcc

### Get table name
tabName=`mysql -h ${host} -P ${port} -u${user} ${password} -s -e "select table_name from information_schema.tables where table_schema='${dbname}'"`

### Get table counts
#tabCounts=`mysql -h ${host} -P ${port} -u${user} -p${password} -e "select count(*) from information_schema.tables where table_schema='${dbname}' group by table_schema"`

### Convert table name array
declare -a tabArry
idx=0
for tab in ${tabName}
do
	tabArry[idx]=${tab}
	if [ $? -eq 0 ]; then
		echo "table ${tab} add to tabArry success."
		echo "------------------------------------"
		echo "tabArry ${idx} table name: "
		echo ""
		echo ${tabArry[idx]}
		echo ""
	else
		echo "table ${tab} add to tabArry failed."
		echo ""
	fi
	let idx++
done

### Analyze table
for name in ${tabArry[*]}
do
	mysql -h ${host} -P ${port} -u${user} ${password} -D ${dbname} -e "analyze table ${dbname}.${name}"
	if [ $? -eq 0 ]; then
		echo "analyze table ${dbname}.${name} success."
	else
		echo "analyze table ${dbname}.${name} failed."
	fi
done
