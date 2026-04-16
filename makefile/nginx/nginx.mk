# makefile/nginx/nginx.mk
# PATH_PROJECT -> Makefile
PROJECT_NGINX = $(PATH_PROJECT)/nginx
IMAGE_NAME = 'nginx-alpine-ncc'

# DOCKERFILE_CONTENT
include nginx/dockerfile_content.mk
export DOCKERFILE_CONTENT

nginx-help:
	@echo "make nginx-build - Build image"
	@echo "make nginx-run - Run image"
	@echo "make nginx-reload - Reload nginx image"

nginx-build:
	@echo "-BUILD-"
	mkdir -p $(PROJECT_NGINX)
	@echo "$$DOCKERFILE_CONTENT" > $(PROJECT_NGINX)/Dockerfile
	docker build -t $(IMAGE_NAME) -f $(PROJECT_NGINX)/Dockerfile $(PROJECT_NGINX)
	@echo "-DONE-"
	docker images

nginx-run:
	@echo "-RUN-"
	@docker rm -f $(IMAGE_NAME) 2>/dev/null || true
	
	mkdir -p $(PROJECT_NGINX)
	cp nginx/default.conf $(PROJECT_NGINX)/default.conf
# 	#index
	mkdir -p $(PROJECT_NGINX)/html
	cp nginx/index.html $(PROJECT_NGINX)/html/index.html
# 	# docker run
	docker run -d --name $(IMAGE_NAME) \
	-v $(PROJECT_NGINX)/html:/var/www/html \
	-v $(PROJECT_NGINX)/default.conf:/etc/nginx/http.d/default.conf \
	-p 8080:80 \
	$(IMAGE_NAME)
	@echo "-DONE-"
	docker ps

nginx-reload:
	docker exec $(IMAGE_NAME) sh -c "nginx -s reload"