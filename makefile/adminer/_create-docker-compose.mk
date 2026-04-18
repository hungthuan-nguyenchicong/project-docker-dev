# makefile/adminer/_create-docker-compose.mk

define DOCKER_COMPOSE_CONTENT
services:
 adminer-app:
  image: $(ADMINER_IMAGE)
  container_name: $(ADMINER_IMAGE)
  init: true  # <--- Rất quan trọng để dọn dẹp zombie từ php-fpm và nginx
  volumes:
   - $(ADMINER_PATH_PROJECT)/www.conf:/etc/php/php-fpm.d/www.conf
  entrypoint: /bin/sh -c "mkdir -p /run/php-fpm; \
		addgroup -S www-data 2>/dev/null; \
      	adduser -D -S -G www-data www-data 2>/dev/null; \
  		chown www-data:www-data /run/php-fpm; \
		exec php-fpm -F"

endef
export DOCKER_COMPOSE_CONTENT

_adminer-create-docker-compose:
	@echo "RUN adminer-docker-compose-up"
	echo "$$DOCKER_COMPOSE_CONTENT" > $(ADMINER_PATH_PROJECT)/docker-compose.yml
	@echo "DONE adminer-docker-compose-up"
