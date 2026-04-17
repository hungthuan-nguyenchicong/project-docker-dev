FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache php curl php-phar php-curl php-mysqli mariadb-client php-mbstring

EXPOSE 9999

WORKDIR /var/www/html

CMD ["sh", "-c", "tail -f >/dev/nul"]
