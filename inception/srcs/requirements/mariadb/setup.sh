#!/bin/sh

set -e

sed -i 's/\[mysqld\]/&\nbind-address=0.0.0.0/1' /etc/my.cnf.d/mariadb-server.cnf

sed -i 's/skip-networking/&=0/' /etc/my.cnf.d/mariadb-server.cnf

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing fresh database..."
    mariadb-install-db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql

    mariadbd-safe &
    mysqld_pid=$!

    until mariadb-admin ping --silent; do
        sleep 1
    done

    mariadb -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    mariadb -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
    mariadb -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
    mariadb -u root -e "FLUSH PRIVILEGES;"
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"

    mariadb-admin -u root -p"$DB_ROOT_PASS" shutdown
    wait $mysqld_pid
    echo "Database initialization complete."
fi

exec mariadbd-safe
