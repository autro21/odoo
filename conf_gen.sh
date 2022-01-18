#!/bin/bash
# --admin-pass	--db_port	--db_user	--db_password
if [[ $# != 19 ]]
then
	echo "not allowed number of args(conf_gen.sh)"
	exit -1
fi
echo "[options]"
echo "; This is the password that allows database operations:"
echo "admin_passwd = $1"
echo "db_host = false"
echo "db_port = $2"
echo "db_user = $3"
echo "db_password = $4"
echo ";db_maxconn = 2048"

echo "addons_path = $5"
echo "data_dir = $6"

echo "xmlrpc = True"
echo "xmlrpc_interface = 127.0.0.1"
echo "xmlrpc_port = $7"
echo "longpolling_port = $8"
echo "dbfilter = $9"
echo "list_db = true"
echo "proxy_mode = true"

echo "workers = ${10}"
echo "max_cron_threads = ${11}"
echo "limit_memory_hard = ${12}"
echo "limit_memory_soft = ${13}"
echo "limit_request = ${14}"
echo "limit_time_cpu = ${15}"
echo "limit_time_real = ${16}"
echo "pidfile = ${17}"
echo "logfile = ${18}"
echo "log_level = ${19}"
echo "log_rotate = true"
