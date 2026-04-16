# makefile/nginx/dockerfile_content.mk
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache nginx

RUN mkdir -p /run/nginx && \
	mkdir -p /var/www/html && \
	chown -R nginx:nginx /run/nginx /var/www/html
# Thêm dòng này vào
EXPOSE 80
# WORK
WORKDIR /var/www/html

CMD ["nginx", "-g", "daemon off;"]
endef