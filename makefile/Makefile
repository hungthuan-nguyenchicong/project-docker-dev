# makefile/Makefile

# Định nghĩa biến gốc
IMAGE_ALPINE = alpine:3.23.3
PATH_PROJECT = $(shell dirname $(PWD))/project-test

#nginx
include nginx/nginx.mk
#php
include php/php.mk

# Mặc định khi gõ 'make' sẽ hiện hướng dẫn
.DEFAULT_GOAL :=help

help:
	@echo "- CAC LENH HO TRO -"
	@echo "-> make pull-alpine - Pull image alpine"
	@echo "-> make nginx-help - Nginx help"
	@echo "-> make php-help - Php help"
pull-alpine:
	docker pull $(IMAGE_ALPINE)
	docker images