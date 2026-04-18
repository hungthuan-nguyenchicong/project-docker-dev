#makefile/adminer/_create-docker-file.mk
#pro
define ADMINER_DOCKERFILE_CONTENT_PRO
FROM $(ALPINE_IMAGE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php-fpm
EXPOSE $(ADMINER_EXPOSE)
WORKDIR $(ADMINER_WORKDIR)

CMD ["sh", "-c", "tail -f >/dev/nul"]
endef

export ADMINER_DOCKERFILE_CONTENT_PRO
# dev
define ADMINER_DOCKERFILE_CONTENT_DEV
FROM $(ALPINE_IMAGE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php84-fpm && \
	ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm && \
	ln -s /etc/php84 /etc/php
EXPOSE $(ADMINER_EXPOSE)
WORKDIR $(ADMINER_WORKDIR)

CMD ["sh", "-c", "tail -f >/dev/nul"]
endef
export ADMINER_DOCKERFILE_CONTENT_DEV

export ADMINER_DOCKERFILE = $(ADMINER_DOCKERFILE_CONTENT_DEV)

_adminer-create-dockerfile: adminer-prepare
	@echo "RUN adminer-create-dockerfile"
	@echo "$$ADMINER_DOCKERFILE" > $(ADMINER_PATH_PROJECT)/Dockerfile
	@echo "DONE adminer-create-dockerfile"