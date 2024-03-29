#!/bin/bash

echo "[Unit]"
echo "Description= odoo$OdooVer instance"
echo "Requires=postgresql.service"
echo "After=network.target postgresql.service"
echo ""
echo "[Service]"
echo "Type=simple"
#identify by project name
echo "SyslogIdentifier=$1"
echo "PermissionsStartOnly=true"
echo "User=odoo$OdooVer"
echo "Group=odoo"
echo "ExecStart=/usr/bin/$1 /opt/odoo$OdooVer/odoo-bin -c /etc/odoo/$1/$1.conf"
echo "StandardOutput=journal+console"
echo "KillMode=mixed"
echo "KillSignal=SIGKILL"
echo "[Install]"
echo "WantedBy=multi-user.target"
