# makefile/mariadb/mariadb.mk
# PATH_PROJECT -> Makefile
PROJECT_MARIADB = $(PATH_PROJECT)/mariadb
IMAGE_NAME = 'mariadb-alpine-ncc'
WORKDIR_MARIADB = /var/lib/mysql
EXPOSE_MARIADB = 3306
# dockerfile content
include mariadb/dockerfile_content.mk
export DOCKERFILE_CONTENT

mariadb-help:
	@echo "make mariadb-build - build image mariadb"
	@echo "make mariadb-run - run image mariadb"
	@echo "mariadb-create-user - create user test"

mariadb-build:
	@echo "--- BUILD ---"
# 	tao thu muc lam viec mariadb
	mkdir -p $(PROJECT_MARIADB)
	@echo " -> Tao xong: $(PROJECT_MARIADB)"
# 	tao dockerfile
	@echo "$$DOCKERFILE_CONTENT" > $(PROJECT_MARIADB)/Dockerfile
	@echo "-> Xong Dockerfile!"
# 	built
	docker build -t $(IMAGE_NAME) -f $(PROJECT_MARIADB)/Dockerfile $(PROJECT_MARIADB)
	docker images

mariadb-run:
	@echo "--- RUN $(IMAGE_NAME) ---"
	@docker rm -f $(IMAGE_NAME) 2>/dev/null || true
# 	# BƯỚC 1: Phải tạo file trước
	@mkdir -p $(PROJECT_MARIADB)
# 	# run
	docker run -d --name $(IMAGE_NAME) \
		-p $(EXPOSE_MARIADB):$(EXPOSE_MARIADB) \
		$(IMAGE_NAME)

	docker ps

mariadb-create-user:
# 	# chui vao bung
	@echo "--- CREATE USER test ---"
	docker exec -it $(IMAGE_NAME) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'127.0.0.1' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

	@echo "--- DONE ---"