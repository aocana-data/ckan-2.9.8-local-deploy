#!/bin/bash

echo ">>>   POSTGRESQL SETUP"
yum module reset postgresql -y
yum module enable postgresql:9.6 -y

echo ">>>   POSTGRESQL INIT DB"
postgresql-setup --initdb
systemctl start postgresql.service
systemctl enable postgresql.service

echo ">>>   POSTGRESQL  USER "
echo ">>>   INGRESAR COMO USUARIO postgres"
echo ">>>   CORRER EL ARCHIVO postgresql_env.sh"


sudo -i -u postgres
