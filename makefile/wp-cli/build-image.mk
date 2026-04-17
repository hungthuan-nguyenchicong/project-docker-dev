# makefile/wp-cli/build-image.mk
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php curl php-phar php-curl php-mysqli mariadb-client php-mbstring

EXPOSE $(WP_CLI_EXPOSE)

WORKDIR $(WP_CLI_WORKDIR)

CMD ["sh", "-c", "tail -f >/dev/nul"]
endef

wp-cli-build-image:
	@echo "BUILD IMAGE"
	mkdir -p $(WP_CLI_PATH_PROJECT)
	@echo "$$DOCKERFILE_CONTENT" > $(WP_CLI_PATH_PROJECT)/Dockerfile

	docker build -t $(WP_CLI_IMAGE) -f $(WP_CLI_PATH_PROJECT)/Dockerfile $(WP_CLI_PATH_PROJECT)

	@echo "DONE"

	docker images
