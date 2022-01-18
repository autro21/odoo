#!/bin/bash

ver=$OdooVer

#odoo_lport : string var in jenkins
for i in "$@";
do
		echo $i is made
		sudo mkdir  /opt/odoo$ver/projects/$i
		cd /opt/odoo$ver/projects/$i
		sudo mkdir data
        sudo mkdir modules

        sudo useradd -d /opt/odoo$ver/projects/$i -s /usr/sbin/nologin -G odoo $i
		sudo chown -R $i:odoo /opt/odoo$ver/projects/$i/
        sudo mkdir /etc/odoo/$i
        #mkdir /etc/odoo/$i/$i.conf
        db_passwd=$(pwgen 25 1)
        admin_passwd=$(pwgen 25 1)
        usr=$i
		if [[ ! -d "$odoo_lport" ]]; then
            odoo_port=9051
		else
			odoo_port=$odoo_lport
		fi

        odoopoll_port=$((odoo_port+1))
		odoo_lport=$((odoopoll_port+1))
        pid_file="/opt/odoo$ver/run/$i.pid"
        log_file="/var/log/odoo/$i.log"
        log_level="debug"
        ln /usr/bin/python3.8 /usr/bin/$i

        echo -e "admin_pass = $admin_passwd\\nuser=$i\\ndb_passwd = $db_passwd" > /opt/odoo${ver}_secrets/$i.txt
        addons_path="/opt/odoo$ver/addons,/opt/odoo$ver/projects/$i/modules"
		echo $addons_path
        ./conf_gen.sh $admin_passwd 5432 $usr $db_passwd $addons_path "/opt/odoo$ver/projects/$i/data" $odoo_port $odoopoll_port $usr 2 1\
                2147483648 2147483648 8192 3600 3600 ${pid_file} ${log_file} ${log_level} > /etc/odoo/$i/$i.conf
		./create_service_odoo.sh $i > /etc/systemd/system/$i.service		
done;
