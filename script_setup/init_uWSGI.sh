#!/bin/bash

path_local='/usr/lib/ckan/ckan/source/'

cp "$path_local/wsgi.py" /etc/ckan/default/
cp /usr/lib/ckan/default/src/ckan/ckan-uwsgi.ini /etc/ckan/default/

sed -i "s/data-www/ckan/g" /etc/ckan/default/ckan-uwsgi.ini 


cat <<- EOF > /etc/systemd/system/ckan.service
[Unit]
Description=CKAN 2.9
After=syslog.target

[Service]
ExecStart=/usr/lib/ckan/default/bin/uwsgi --ini /etc/ckan/default/ckan-uwsgi.ini
# Requires systemd version 211 or newer
RuntimeDirectory=ckan
Restart=always
KillSignal=SIGQUIT
Type=notify
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target
EOF


path_local='/usr/lib/ckan/ckan/source/'
cat "$path_local/wsgi.py"
