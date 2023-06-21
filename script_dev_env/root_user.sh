#!/bin/bash

echo ">>>   LEVANTANDO TODOS LOS SERVICIOS NECESARIOS PARA DOCKER - HTTPD - REDIS"

systemctl restart postgresql.service
echo ">>>   REINICIO DE BASE DE DATOS LOCAL"

systemctl start docker
systemctl enable docker
echo ">>>   ARRANQUE DE DOCKER PARA USAR SOLR8"
sudo docker compose -f /home/sync_folder/solr/docker-compose.yml up -d --build 
echo ">>>   LEVANTANDO DOCKER COMPOSE"

systemctl enable redis
systemctl start redis
echo ">>>   INICIO DE REDIS"
# systemctl status redis

systemctl enable httpd
systemctl start httpd
echo ">>>   INICIO DE HTTPD"
# systemctl status httpd


sudo docker container ls
echo ">>>   HABILITADO EL CONTENEDOR DE SOLR"

echo ">>>   CREANDO EL USUARIO CKAN"

useradd -m -s /sbin/nologin -d /usr/lib/ckan -c "CKAN User" ckan

echo ">>>   AGREGANDO A LOS USUARIOS DEL TIPO SUDOERS"

echo "ckan ALL=(ALL:ALL) ALL" >> /etc/sudoers 


# optional:: generar ckan passwd
# sudo passwd ckan

echo ">>>   CREANDO LA CARPETA PARA GENERAR EL ENTORNO"

cd /usr/lib/ckan
chmod 755 /usr/lib/ckan

echo ">>>   CREANDO LA CARPETA FIRESTORE"

sudo mkdir -p /var/lib/ckan/default && cd /var/lib/ckan/default
sudo chown ckan /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default

echo ">>>   INSTALANDO EL ENTORNO"
echo ">>>   INGRESAR COMO USUARIO ckan"
echo ">>>   CORRER EL ARCHIVO ckan_user.sh"

su -s /bin/bash - ckan


