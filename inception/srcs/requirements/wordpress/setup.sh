#!/bin/sh

set -e

# Ensure PHP-FPM listens on port 9000 for NGINX fastcgi proxy
sed -i 's/listen = 127.0.0.1:9000/listen = 9000/1' /etc/php83/php-fpm.d/www.conf

echo "Waiting for MariaDB connection..."
until mariadb-admin ping -h"mariadb" -u"$DB_USER" -p"$DB_PASS" --silent; do
    sleep 2
done
echo "MariaDB is ready."

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress is not installed. Running initial setup..."

    if [ ! -f "wp-config.php" ]; then
        wp core download --allow-root --force
        wp config create \
            --dbname="$DB_NAME" \
            --dbuser="$DB_USER" \
            --dbpass="$DB_PASS" \
            --dbhost="mariadb" \
            --allow-root
    fi

    wp core install --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASS" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --skip-email \
                    --allow-root

    if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
        wp user create "$WP_USER" "$WP_EMAIL" --role=author --user_pass="$WP_PASS" --allow-root
    fi

    wp theme install twentytwentyfour --activate --allow-root || true
else
    echo "WordPress is already installed. Skipping initialization."
fi

chown -R nobody:nobody /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

exec php-fpm83 -F
