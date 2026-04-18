#makefile/adminer/_docker-build.mk

include adminer/_create-dockerfile.mk
_adminer-docker-build:
	@echo "RUN _adminer-docker-build"
	$(MAKE) _adminer-create-dockerfile

	docker build -t $(ADMINER_IMAGE) \
		-f $(ADMINER_PATH_PROJECT)/Dockerfile $(ADMINER_PATH_PROJECT)

	@echo "DONE _adminer-docker-build"

	docker images