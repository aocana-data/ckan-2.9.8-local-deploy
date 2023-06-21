#!/bin/bash

sudo su

set -e

# Dado a que cuando se hace la integracion con los modulos de CKAN
# el schema se vuelve no mutable, para poder modificarlo es necesario modificarlo
# hay que hacer una modificación sobre las configuraciones de solr

sed -i 's/{update.autoCreateFields:true}/{update.autoCreateFields:false}/g'  /home/sync_folder/solr/configuraciones/solrconfig.xml

systemctl start docker
sudo docker compose -f /home/sync_folder/solr/docker-compose.yml up -d --build 
systemctl start redis
systemctl start httpd


cd /usr/lib/ckan/ckan/configuraciones 

# En esta etapa te va a pedir el passwd de este usuario.
# sea el caso de que no lo llegue a tener se lo podes crear con el comando
# passwd ckan (este comando corre bajo el usuario root)


su -s /bin/bash - ckan -c \
" . /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/ckan/configuraciones  && ckan run  --port=5000 --host=0.0.0.0"


