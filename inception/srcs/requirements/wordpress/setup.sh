#!/bin/sh

set -x

wp core download --force

mv wp-config-sample.php wp-config.php 

wp config set DB_NAME $DB_NAME
wp config set DB_USER $DB_USER
wp config set DB_PASSWORD $DB_PASS
wp config set DB_HOST 'mariadb'

sed -i 's/listen = 127.0.0.1:9000/listen = 9000/1' /etc/php83/php-fpm.d/www.conf

wp core install --url=$DOMAIN_NAME \
                --title=$WP_TITLE \
                --admin_user=$WP_ADMIN_USER \
                --admin_password=$WP_ADMIN_PASS \
                --admin_email=$WP_ADMIN_EMAIL \
                --skip-email 


wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS 


wp theme install twentytwentyfour --activate

chmod -R 755 /var/www/html/wordpress

exec php-fpm83 -F
