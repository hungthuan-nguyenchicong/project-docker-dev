# makefile/mariadb/dockerfile_content.mk
# mariadb docker file content
# var root makefile: IMAGE_ALPINE = alpine:3.23.3
define DOCKERFILE_CONTENT

FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache mariadb mariadb-client

# tao thu muc laf viec run cap quyen
RUN mkdir -p /run/mysqld && \
	mkdir -p /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql
# /run/mysqld
# mariadb-install-db --user=mysql --datadir=/var/lib/mysql
# Bước này tạo các bảng hệ thống cần thiết để DB có thể khởi động
# RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# WORKDIR_MARIADB => mariadb.mk
WORKDIR $(WORKDIR_MARIADB)
# EXPOSE_MARIADB => mariadb.mk
EXPOSE $(EXPOSE_MARIADB)
# luu y mysqld => mariadbd
CMD ["mariadbd", "--user=mysql", "--console", "--bind-address=0.0.0.0", "--skip-networking=0"]
endef