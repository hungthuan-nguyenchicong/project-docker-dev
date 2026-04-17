# makefile/nginx/nginx.mk
# PATH_PROJECT -> Makefile
PROJECT_NGINX = $(PATH_PROJECT)/nginx
NGINX_IMAGE = 'nginx-alpine-ncc'

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
	@echo "-RUN- $(NGINX_IMAGE)"
	@docker rm -f $(NGINX_IMAGE) 2>/dev/null || true
	
	mkdir -p $(PROJECT_NGINX)
	cp nginx/default.conf $(PROJECT_NGINX)/default.conf
# 	#index
	mkdir -p $(PROJECT_NGINX)/html
	cp nginx/index.html $(PROJECT_NGINX)/html/index.html
# 	# docker run
	docker run -d --name $(NGINX_IMAGE) \
	-v $(PROJECT_NGINX)/html:/var/www/html \
	-v $(PROJECT_NGINX)/default.conf:/etc/nginx/http.d/default.conf \
	-p 8088:80 \
	$(NGINX_IMAGE)
	@echo "-DONE-"
	docker ps

nginx-reload:
	docker exec $(NGINX_IMAGE) sh -c "nginx -s reload"