FROM alpine:3.21

RUN apk update && apk add nginx openssl

RUN mkdir -p /run/php && \
        mkdir -p /var/www/html;

COPY setup.sh /setup.sh

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["sh", "/setup.sh"]

