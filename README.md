## BADATA

HERRAMIENTAS DE VIRTUALIZACIÓN:

-   Vagrant
    -   Vagranfile:

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.disksize.size = '20GB'
  config.vm.network "forwarded_port", guest: 5000, host: 5000, host_ip: "127.0.0.1"

  config.vm.synced_folder ".", "/home/sync_folder" , type: "rsync"

  config.vm.provision "shell",  path: "./script_setup/init_vm.sh"

end



```

-   VirtualBox 6.1.38

---

OS :

-   Distribuciones RHEL >> CentOS release-os 8

-   Para levantar este entorno con CKAN como SOURCE se utiliza el repositorio y para levantarlo se procede una secuencia de scripts ordenados para su funcionamiento semiautomatizado.
-   REQUERIMIENTOS:
    -   PYTHON3.9.7
    -   [SOLR](/solr/) ==> LEVANTADO COMO RECURSO USANDO UN CONTENEDOR
    -   DB ==> POSTGRESQL 9.6
    -   REDIS
    -   Storage Size : Default 20GB

## SCRIPTS

Todos estos procesos se encuentran ordenados de tal forma que ejecutan secuencialmente los pasos para levantar ckan en un servidor local.

Ckan se encuentra levantado como una dependencia utilizando los procesos que se encuentran en el archivo setup.py

Se utiliza como repositorio de desarrollo el repositorio

branch: s2i/ckan-2.9.8
link: https://repositorio-asi.buenosaires.gob.ar/ssppbe/ba-data/ckan.git

Los archivos levantados en configuraciones se utilizaron para realizar este proyecto y colocarlos en alta.

Los siguientes scripts tienen especificaciones de que es lo que realiza en cada etapa, a continuación se detalla brevemente el trabajo general que realiza.

1. [script_inicio_dependencias_server](/script_setup/init_vm.sh) :

    Genera el soporte de dependecias para generar el entorno optimo en el servidor.

    En este script de arranque se instalan los paquetes de postgresql, redis, docker, se instalan dependencias globales de python, se instala python3.9.7 y se reinicia el servidor

2. [steps_ckan_solr_postgres](/script_dev_env/steps_ckan_solr_postgres.sh)

    - source /home/sync_folder/script_dev_env/steps_ckan_solr_postgres.sh

        Genera el inicio de las instancias de postgresql 9.6, y el usuario de postgres

3. [postgresql_env](/script_dev_env/postgresql_env.sh)

    - source /home/sync_folder/script_dev_env/postgresql_env.sh

    Realizar la generaciónde los usuarios ckan y datastore para las bases necesarias de ckan.

4. [root_user](/script_dev_env/root_user.sh)

    - source /home/sync_folder/script_dev_env/root_user.sh

    Genera todos los servicios activados de SOLR, REDIS, HTTPD.
    Crea una carpeta y le da permisos para el firestore

5. [ckan_user](/script_dev_env/ckan_user.sh)

    - source /home/sync_folder/script_dev_env/ckan_user.sh

    Levanta las dependencias requeridas por los requirements, usando el punto de entrada setup.py

    ```
    pip install .
    ```

## CONSIDERACIONES EN EL ARCHIVO ckan.ini

CAMBIAR LOS SITE SETTINGS

```
 ckan.site_url = http://127.0.0.1:5000
```

CAMBIAR LOS DB SETTINGS

```
sqlalchemy.url = postgresql://ckan:ckan@127.0.0.1/ckan

ckan.datastore.write_url = postgresql://ckan:ckan@127.0.0.1/datastore
ckan.datastore.read_url = postgresql://datastore:ckan@127.0.0.1/datastore
```

-   CAMBIAR EL X_SENDFILE --> SI ES QUE NO ESTÁ UTILIZANDO NINGUN WEB SERVER DISTINTO A WERKZEUG

-   CAMBIAR LA RUTA DE LOS ASSETS QUE ALMACENA EL PLUGIN

```
## Webassets Settings
ckan.webassets.use_x_sendfile = false
# indica la ruta donde va a estar tomando los assets del plugin (carpeta de estáticos)
ckan.webassets.path = <en la ruta donde se encuentre los assets de gobar_theme>
```

-   PREVIO A LA IMPORTACIÓN DE LOS DATOS, ES NECESARIO ENTENDER UN PAR DE SITUACIONES
    -   EL USUARIO ckan DEBERÁ CONTAR CON UN PASSWORD PARA PODER ACCEDER Y HACER MODIFICACIONES.
    -   LA CONFIGURACION DE SOLR DEBERÁ PERMITIRLE QUE EL SCHEMA SEA DEL TIPO MUTABLE

## MIGRAR UNA BASE DE DATOS

[db_migration](/script_dev_env/db_migration.sh)

    - source /script_dev_env/db_migration.sh
