#!/bin/bash


mkdir -p /usr/lib/ckan/default
chown `whoami` /usr/lib/ckan/default
python3.9 -m venv /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

pip3 install --upgrade pip

cd /usr/lib/ckan
git clone -b s2i/ckan-2.9.8 https://repositorio-asi.buenosaires.gob.ar/ssppbe/ba-data/ckan.git

# DESCARGAR EL REPOSITORIO Y EMPEZAR A TRABAJAR EN ESTA CARPETA DE CONFIGURACIONES
# AL DESCARGAR EL REPOSITORIO NOS VIENE INCLUIDO EL ARCHIVO setup.py, el cual 
# CONTIENE LA INSTALACION DEL PAQUETE, EN ESTE CASO CKAN.
# ES NECESARIO COMO PARTE ADICIONAL INSTALAR LOS REQUIREMENTS.

cd /usr/lib/ckan/ckan/source
pip install -r requirement-setuptools.txt
pip install -r requirements.txt
pip install .

cd /usr/lib/ckan/ckan/configuraciones

# CAMBIAR LOS SITE SETTINGS
# ckan.site_url = http://127.0.0.1:5000

# CAMBIAR LOS DB SETTINGS
# sqlalchemy.url = postgresql://ckan:ckan@127.0.0.1/ckan

# ckan.datastore.write_url = postgresql://ckan:ckan@127.0.0.1/datastore
# ckan.datastore.read_url = postgresql://datastore:ckan@127.0.0.1/datastore

# CAMBIAR EL X_SENDFILE --> SI ES QUE NO ESTÁ UTILIZANDO NINGUN WEB SERVER DISTINTO A WERKZEUG
# CAMBIAR LA RUTA DE LOS ASSETS QUE ALMACENA EL PLUGIN

## Webassets Settings
# ckan.webassets.use_x_sendfile = false
# ckan.webassets.path = <en la ruta donde se encuentre los assets de gobar_theme>

sed -i "s/ckan.webassets.path \= \/opt\/app-root\/src\/ckanext\/gobar_theme\/assets/ckan.webassets.path = \/usr\/lib\/ckan\/ckan\/source\/ckanext\/gobar_theme\/assets/g" ckan.ini 

# permisos de datastore
ckan -c ckan.ini datastore set-permissions
ckan -c ckan.ini db init

cd /usr/lib/ckan/ckan/configuraciones && ckan run  --port=5000 --host=0.0.0.0