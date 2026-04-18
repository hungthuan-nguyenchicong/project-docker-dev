# makefile/adminer/_docker-compose.mk

include adminer/_create-docker-compose.mk

_adminer-docker-compose-up:
	@echo "RUN _adminer-docker-compose-up"
	$(MAKE) _adminer-create-docker-compose

	docker compose -f $(ADMINER_PATH_PROJECT)/docker-compose.yml \
		--project-directory $(ADMINER_PATH_PROJECT) up -d
	@echo "DONE _adminer-docker-compose-up"

	docker ps

_adminer-docker-compose-down:
	docker compose -f $(ADMINER_PATH_PROJECT)/docker-compose.yml down

	docker ps

_adminer-docker-compose-down-v:
	docker compose -f $(ADMINER_PATH_PROJECT)/docker-compose.yml down -v
	docker ps

_adminer-docker-cp-volumes:
# 	# Copy file www.conf từ container ra thư mục hiện tại
# 	#ocker cp adminer-alpine-ncc:/etc/php/php-fpm.d/www.conf $(ADMINER_PATH_PROJECT)/www.conf
# 	# Tạo một container tạm, không mount, chỉ để copy file
	@echo "RUN _adminer-docker-cp"
	docker run --rm --entrypoint "" adminer-alpine-ncc cat /etc/php/php-fpm.d/www.conf > $(ADMINER_PATH_PROJECT)/www.conf
	@echo "DONE _adminer-docker-cp"