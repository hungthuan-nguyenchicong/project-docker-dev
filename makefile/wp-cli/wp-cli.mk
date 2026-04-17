# makefile/wp-cli/wp-cli.mk

# PATH_PROJECT -> Makefile
WP_CLI_PATH_PROJECT = $(PATH_PROJECT)/wp-cli

WP_CLI_IMAGE = wp-cli-alpine-ncc
WP_CLI_WORKDIR = /var/www/html
WP_CLI_EXPOSE = 9999

# build image
include wp-cli/build-image.mk

wp-cli-help:
	@echo "make wp-cli-run-build - wp-cli-run-build"
	@echo "make wp-cli-docker-run-dev - wp-cli-docker-run-dev"
wp-cli-run-build:
	@echo "_BUILD_"
	$(MAKE) wp-cli-build-image
wp-cli-setup-default:
	mkdir -p $(WP_CLI_PATH_PROJECT)
	mkdir -p $(WP_CLI_PATH_PROJECT)/html
wp-cli-docker-run-dev:
	@echo "docker run dev"
	$(MAKE) wp-cli-setup-default
	docker rm -f $(WP_CLI_IMAGE) 2>/dev/null || true

	docker run -d --name $(WP_CLI_IMAGE) \
	--network db-network \
	--restart always \
	-p $(WP_CLI_EXPOSE):8080 \
	-v $(WP_CLI_PATH_PROJECT)/html:/var/www/html \
	$(WP_CLI_IMAGE)

	docker ps

wp-cli-install-wp:
	docker exec -u root $(WP_CLI_IMAGE) sh -c "\
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	wp --info --allow-root"

