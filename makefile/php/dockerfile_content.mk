# php dockerfile content
# var root makefile: IMAGE_ALPINE = alpine:3.23.3
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php

# EXPOSE_PHP -> php.mk
EXPOSE $(EXPOSE_PHP)
# WORKDIR_PHP -> php.mk
WORKDIR $(WORKDIR_PHP)

CMD ["php", "-S", "0.0.0.0:$(EXPOSE_PHP)", "-t", "/var/www/html"]
endef