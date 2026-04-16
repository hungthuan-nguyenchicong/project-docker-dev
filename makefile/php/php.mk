# makefile/php/php.mk

# PATH_PROJECT -> Makefile
PROJECT_PHP = $(PATH_PROJECT)/php
IMAGE_NAME = 'php-alpine-ncc'
WORKDIR_PHP = /var/www/html
EXPOSE_PHP = 8888
# php extensions
PHP_EXTENSIONS = php-pdo php-pdo_mysql php-session
# link adminer
ADMINER_URL = https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php

# DOCKERFILE_CONTENT
include php/dockerfile_content.mk
export DOCKERFILE_CONTENT

php-help:
	@echo "make php-build - Build image"
	@echo "make php-run - Run image"
	@echo "make php-add-extension - Add extension"
	@echo "make php-setup-adminer - Setup adminer"

php-build:
	@echo "-BUILD-"
	mkdir -p $(PROJECT_PHP)
# 	# 	docker file conten
	@echo "$$DOCKERFILE_CONTENT" > $(PROJECT_PHP)/Dockerfile
	@echo "xong Dockerfile"
# 	docker build - chay tu pwd root makefile => thuc thi file $(PATH_PHP)/Dockerfile . @: thay . =: $(PATH_PHP)
	docker build -t $(IMAGE_NAME) -f $(PROJECT_PHP)/Dockerfile $(PROJECT_PHP)
	@echo "-DONE-"
	docker images

php-run:
	@echo "_RUN_"
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true
# 	# 	tao thu muc - truong hop built chua tao hoac thay doi
	mkdir -p $(PROJECT_PHP);
# 	tao thu muc html tai noi chay project
	mkdir -p $(PROJECT_PHP)/html
# 	phpinfo.php
	echo "<?php phpinfo(); ?>" > $(PROJECT_PHP)/html/index.php
# 	docker run
	docker run -d --name $(IMAGE_NAME) \
	-v $(PROJECT_PHP)/html:/var/www/html \
	-p $(EXPOSE_PHP):$(EXPOSE_PHP) \
	$(IMAGE_NAME)

	@echo "_DONE_"
	docker ps

php-add-extension:
	@echo "--- Add extension ---"
	@echo "--- Cai dat tat ca extension cung luc ---"
	docker exec -it $(IMAGE_NAME) sh -c "apk add --no-cache $(PHP_EXTENSIONS)"
	@echo "--- Khoi dong lai container de ap dung thay doi ---"
	docker restart $(IMAGE_NAME)
	@echo "--- Da add: $(PHP_EXTENSIONS) ---"

php-setup-adminer:
	@echo "--- SETUP ADMINER ---"
# 	add curl
	apk add --no-cache curl
# 	tao thu muc adminer
# 	mkrdir -p $(PATH_PHP)/html/adminer
# 	chui vao bung container
	docker exec -it $(IMAGE_NAME) sh -c "apk add --no-cache curl"
# 	tai file adminer.index
	@echo "--- Dang tai Adminer vao thu muc vua tao ---"
# 	curl -L $(ADMINER_URL) -o $(PATH_PHP)/html/adminer/index.php
# 	chui vao bung container
	docker exec -it $(IMAGE_NAME) sh -c "mkdir -p $(WORKDIR_PHP)/adminer && curl -L $(ADMINER_URL) -o $(WORKDIR_PHP)/adminer/index.php"
	@echo "---DONE SETUP ADMINER ---"