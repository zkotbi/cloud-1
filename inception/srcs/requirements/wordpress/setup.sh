#!/bin/sh
set -e

cd /var/www/html/wordpress

mkdir -p /run/php
 
echo "Waiting for MariaDB..."

until mariadb-admin ping \
    -h mariadb \
    -u root \
    -p"$DB_ROOT_PASS" \
    --silent
do
    sleep 2
done

echo "MariaDB is ready."

if [ ! -f wp-load.php ]; then
    echo "WordPress files not found. Downloading WordPress..."
    wp core download
else
    echo "WordPress files already exist. Skipping download."
fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."

    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="mariadb"
else
    echo "wp-config.php already exists. Skipping configuration."
fi

if ! wp core is-installed 2>/dev/null; then
    echo "WordPress is not installed. Installing..."

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email

    echo "Creating WordPress user..."

    wp user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --role=author \
        --user_pass="$WP_PASS"

    echo "Installing WordPress theme..."

    wp theme install twentytwentyfour --activate
else
    echo "WordPress is already installed. Skipping initialization."
fi

sed -i 's/listen = 127.0.0.1:9000/listen = 9000/1' \
    /etc/php83/php-fpm.d/www.conf

chmod -R 755 /var/www/html/wordpress

echo "Starting PHP-FPM..."

exec php-fpm83 -F
