# makefile/adminer/adminer.mk

ADMINER_PATH_PROJECT = $(PATH_PROJECT)/adminer
ADMINER_IMAGE = adminer-alpine-ncc
ADMINER_EXPOSE = 3366
ADMINER_WORKDIR = /var/www/html


include adminer/_docker-build.mk
include adminer/_docker-compose.mk

adminer-help:
	@echo "make adminer-docker-build - adminer-docker-build"
	@echo "make adminer-docker-cp-volumes"
	@echo "make adminer-docker-compose-up -adminer-docker-compose-up"
	@echo "make adminer-docker-compose-down"
	@echo "make adminer-docker-compose-down-v"
adminer-prepare:
	mkdir -p $(ADMINER_PATH_PROJECT)
	mkdir -p $(ADMINER_PATH_PROJECT)/html

adminer-docker-build:
	@echo "RUN - adminer-docker-build"
	$(MAKE) _adminer-docker-build
	@echo "DONE - adminer-docker-build"

adminer-docker-compose-up:
	@echo "RUN - adminer-docker-compose-up"
	$(MAKE) _adminer-docker-compose-up
	@echo "DONE - adminer-docker-compose-up"

adminer-docker-compose-down:
	$(MAKE) _adminer-docker-compose-down

adminer-docker-compose-down-v:
	$(MAKE) _adminer-docker-compose-down-v

adminer-docker-cp-volumes:
	$(MAKE) _adminer-docker-cp-volumes