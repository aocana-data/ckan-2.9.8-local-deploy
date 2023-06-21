#!/bin/bash

echo ">>>   USUARIO postgres"

# te va a pedir un password, pero sea el caso que no te lo pida
# directamente se altera directamente con eso
createuser -S -D -R -P ckan
createuser -S -D -R -P -l datastore

psql -c "ALTER USER ckan PASSWORD 'ckan';"
createdb -O ckan ckan -E utf-8

psql -c "ALTER USER datastore PASSWORD 'datastore';"
createdb -O ckan datastore -E utf-8

psql -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE ROLE datastore_ro NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'datastore_ro';
    GRANT ALL PRIVILEGES ON DATABASE datastore TO ckan;
EOSQL

echo ">>>   MODIFICACION DE LOS ARCHIVOS RESPECTIVOS A pg_hba.conf"

# sed -i "s/peer/md5/g"  /var/lib/pgsql/data/pg_hba.conf
# sed -i "s/ident/md5/g"  /var/lib/pgsql/data/pg_hba.conf
# echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf


cat <<- EOF > /var/lib/pgsql/data/pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             postgres                                peer
# IPv4 local connections:
host    all             postrgres       127.0.0.1/32            md5
# IPv6 local connections:

host    all             postgres        127.0.0.1/32            ident
host    all             ckan            0.0.0.0/0               md5
host    all             ckan            ::1/32                  md5
EOF

echo ">>>   CREANDO LEVANTANDO LOS SISTEMAS BAJO EL USUARIO ROOT"
echo ">>>   CORRER EL ARCHVO root_user.sh"
exit
