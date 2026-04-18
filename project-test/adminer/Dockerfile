FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache php84-fpm && ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm && ln -s /etc/php84 /etc/php
EXPOSE 3366
WORKDIR /var/www/html

CMD ["sh", "-c", "tail -f >/dev/nul"]
