sudo su

echo ">> INICIANDO ENV DE REPOSITORIO DE CENTOS 8"

cd /etc/yum.repos.d/ 

# SE HACEN MODIFICACIONES EN LOS ARCHIVOS DE REPOSITORIOS DE CENTOS
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* 
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sed -i -e "s|#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial|gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle|g" /etc/yum.repos.d/CentOS-*


# ACTUALIZACION DE DEPENDENCIAS NECESARIAS PARA CORRER LOS PROGRAMAS
yum install -y epel-release 

yum update -y

yum upgrade -y

rpm --import "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle"



# INSTALACION DE PAQUETES DE GIT ,  EDITOR NANO ,SERVICIO HTTP(PARA HABILITAR LOS PUERTOS)
# E IDIOMAS

yum install -y \
git \
nano \
langpacks-en \
glibc-all-langpacks \
httpd

localectl set-locale LANG=es_AR.UTF-8

echo ">> INSTALANDO DEPENDENCAS NECESARIAS PARA CORRER LA VM"

yum install -y \
wget \
git-core \
java-11-openjdk \
maven \
lsof \
redis \
gcc \
gcc-c++ \
cmake \
make	\
automake \
gmp-devel \
boost \
openssl-devel \
bzip2-devel \
libffi-devel \
zlib* \
curl \
policycoreutils-python-utils \
python3-policycoreutils \
python3-devel \
libpq-devel \
python3-pip \
python3-virtualenv  

echo ">> INSTANCIAS PARA PYTHON GLOBAL"

pip3 install psycopg2-binary
pip3 install pylons
pip3 install uwsgi
pip3 install supervisor
pip3 install PasteScript
pip3 install PasteDeploy

# INSTALACION DE POSTGRESQL 9.6 => postgresql.service

echo ">> INSTANCIAS PARA POSTGRESQL GENERAL USANDO dnf"

yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

cd /etc/yum.repos.d/

cat <<- EOF > /etc/yum.repos.d/pgdg-redhat-all.repo
[pgdg90]
name=PostgreSQL 9.6 RPMs for RHEL/CentOS 7
baseurl=https://yum-archive.postgresql.org/9.6/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
EOF


dnf module list postgresql
dnf install -y @postgresql:9.6 
dnf install -y postgresql-contrib


# AGREGADO DE MANERA GLOBAL Y PERSISTENTE DE POSTGRESQL COMO VARIABLE DE ENTORNO

cat <<- EOF > ~/.bashrc

# .bashrc
# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
	fi
	
	
LD_LIBRARY_PATH=/usr/local/pgsql/lib
PATH=/usr/local/pgsql/bin:$PATH
PATH=/usr/pgsql-9.6/bin:$PATH
EOF

# INSTALANDO PYTHON 3.9.7
echo ">> INSTALANDO PYTHON 3.9.7"

sudo yum groupinstall "Development Tools" -y
cd /opt/ &&  wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz 

tar zxvf Python-3.9.7.tgz 

cd Python-3.9.7/ 
./configure --enable-optimizations 

sudo make && sudo make altinstall
sudo echo "PATH=$(pwd):$PATH" >> ~/.bashrc 

cd .. && sudo rm -rf Python-3.9.7.tgz

# INSTALANDO DOCKER
echo ">> INSTALANDO DOCKER"

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine


sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# NO ES NECESARIO DEL TODO DESABILITAR ESTO
# SIN EMBARGO PODRIA SER UNA CAUSA ADICIONAL SI ES QUE EL USUARIO NO ES UN SUDOER
# POR LO CUAL NO HACE FALTA DESHABILITARLO
# sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 

echo ">> REINICIANDO SISTEMA"
echo ">> INGRESA COMO USUARIO ROOT"
echo ">> RUN SCRIPT steps_ckan_solr_postres.sh"
shutdown -r now

