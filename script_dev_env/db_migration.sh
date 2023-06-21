#!/bin/bash

# como usuario ckan
su -s /bin/bash - ckan 

. /usr/lib/ckan/default/bin/activate 

cd /usr/lib/ckan/ckan/configuraciones

# caso de que se desee hacer un dump de los datos en la bd
# sudo -u postgres pg_dump --format=custom -d ckan > ckan.dump

echo ">>>   LIMPIEZA DE LA DATABASE"
ckan -c ckan.ini db clean --yes

echo ">>>   PARA ESTE SECTOR EL USUARIO CKAN DEBE CONTAR CON PASSWORD"

# esto es para más adelante, pero podría ser para hacer un restore por
# pipes

# PGPASSWORD=ckan pg_dump --verbose --format c \
#     --host localhost --username ckan ckan \
#     | pg_restore --verbose --exit-on-error \
#     --username ckan --dbname ckan

echo ">>>   DE COMPRESS dump files"

tar -xzf db_migration.tar.gz  

echo ">>>   IMPORTACION DE LA BASE DE DATOS POR MEDIO DE UN DMP"
# el localhost puede cambiar

sudo psql -U ckan -h localhost  -d ckan -f /home/sync_folder/database/database_dump_ckan.dmp
sudo psql -U ckan -h localhost  -d datastore -f /home/sync_folder/database/database_dump_datastore.dmp

echo ">>>   RECOMENDACION DE DOCUMENTACION HACER UN DB UPGRADE"
ckan db upgrade

echo ">>>   REINDEX DEL SEARCH INDEX"
ckan -c ckan.ini search-index rebuild




