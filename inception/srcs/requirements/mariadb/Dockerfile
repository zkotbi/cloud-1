FROM alpine:3.21

RUN apk update && apk add mariadb mariadb-client

RUN mkdir -p /run/mysqld && \
        chown -R mysql:mysql /run/mysqld && \ 
        chmod -R 744 /run/mysqld 

COPY ./setup.sh /setup.sh

CMD ["sh", "/setup.sh"]

