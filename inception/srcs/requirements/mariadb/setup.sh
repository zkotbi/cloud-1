#!/bin/sh

set -x

sed -i 's/\[mysqld\]/&\nbind-address=0.0.0.0/1' /etc/my.cnf.d/mariadb-server.cnf

sed -i 's/skip-networking/&=0/' /etc/my.cnf.d/mariadb-server.cnf

mariadb-install-db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql

mariadbd-safe &

mysqld_pid=$!

mariadb-admin ping -u root -p$DB_ROOT_PASS --silent --wait 

mariadb --user=root -p$DB_ROOT_PASS -e  "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mariadb --user=root -p$DB_ROOT_PASS -e  "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
mariadb --user=root -p$DB_ROOT_PASS -e  "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mariadb --user=root -p$DB_ROOT_PASS -e  "FLUSH PRIVILEGES;"
mariadb --user=root -p$DB_ROOT_PASS -e  "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS' ;"

mariadb-admin -u root -p$DB_ROOT_PASS shutdown

wait $mysqld_pid

exec mariadbd-safe

