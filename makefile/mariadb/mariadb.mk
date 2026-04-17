# makefile/mariadb/mariadb.mk
# PATH_PROJECT -> Makefile
PROJECT_MARIADB = $(PATH_PROJECT)/mariadb
MARIADB_IMAGE = 'mariadb-alpine-ncc'
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
	docker build -t $(MARIADB_IMAGE) -f $(PROJECT_MARIADB)/Dockerfile $(PROJECT_MARIADB)
	docker images

mariadb-run:
	@echo "--- RUN $(MARIADB_IMAGE) ---"
	@docker rm -f $(MARIADB_IMAGE) 2>/dev/null || true
# 	# BƯỚC 1: Phải tạo file trước
	@mkdir -p $(PROJECT_MARIADB)
# 	# run
	docker run -d --name $(MARIADB_IMAGE) \
		--network db-network \
    	--restart always \
		-p $(EXPOSE_MARIADB):$(EXPOSE_MARIADB) \
		$(MARIADB_IMAGE)
	
	docker ps

mariadb-create-user:
# 	# chui vao bung
	@echo "--- CREATE USER test ---"
	docker exec -it $(MARIADB_IMAGE) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'127.0.0.1' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

	@echo "--- DONE ---"