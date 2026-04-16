FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache php

# EXPOSE_PHP -> php.mk
EXPOSE 8888
# WORKDIR_PHP -> php.mk
WORKDIR /var/www/html

CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
