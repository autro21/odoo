#!/bin/bash
#sam
ver=$OdooVer
Home=`pwd`
#odoo_lport : string var in jenkins
for i in "$@";
do
		echo "$i is made"
		sudo mkdir -p /opt/odoo$ver/projects/$i
		cd /opt/odoo$ver/projects/$i
		sudo mkdir -p data
        sudo mkdir -p modules

        sudo useradd -d /opt/odoo$ver/projects/$i -s /usr/sbin/nologin -G odoo $i
		sudo chown -R $i:odoo /opt/odoo$ver/projects/$i/
        sudo mkdir -p /etc/odoo/$i
        #mkdir /etc/odoo/$i/$i.conf
        db_passwd=$(pwgen 25 1)
        admin_passwd=$(pwgen 25 1)
        usr=$i
		odoo_port=$odoo_lport

        odoopoll_port=$((odoo_port+1))
		odoo_lport=$((odoopoll_port+1))
        pid_file="/opt/odoo$ver/run/$i.pid"
        log_file="/var/log/odoo/$i.log"
        log_level="debug"
        cd $Home;
        Curr=$Home
        ln /usr/bin/python3.8 /usr/bin/$i
        addons_path="/opt/odoo$ver/addons,/opt/odoo$ver/projects/$i/modules"
        ./conf_gen.sh $admin_passwd 5432 $usr $db_passwd $addons_path "/opt/odoo$ver/projects/$i/data" $odoo_port $odoopoll_port $usr 2 1\
                2147483648 2147483648 8192 3600 3600 ${pid_file} ${log_file} ${log_level} > $Curr/$i.conf
        sudo chown $i:odoo $Curr/$i.conf
        sudo mv $Curr/$i.conf /etc/odoo/$i/$i.conf
        touch /opt/odoo$ver/run/ 
		./create_service_odoo.sh $i > $Curr/$i.service
        sudo chown $i:odoo $Curr/$i.service
        sudo mv $Curr/$i.service /etc/systemd/system/$i.service
done;
sudo systemctl daemon-reload
systemctl stop nginx $@
systemctl start nginx $@
./monitors.sh
