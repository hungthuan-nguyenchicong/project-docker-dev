# fix php-fpm

ls /usr/sbin

ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

netstat -tulpn | grep :9000

ln -s /etc/php84 /etc/php

/etc/php/php-fpm.d/www.conf

; Thay vì:
; listen = 127.0.0.1:9000

; Hãy đổi thành:
listen = /run/php-fpm.sock

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

/etc/php/php-fpm.d/www.conf

volumes:
 - www.conf:/etc/php/php-fpm.d/www.conf

user = www-data
group = www-data

	docker run --rm --entrypoint "" adminer-alpine-ncc cat /etc/php/php-fpm.d/www.conf > $(ADMINER_PATH_PROJECT)/www.conf


entrypoint: /bin/sh -c "mkdir -p /run/php-fpm; \
		addgroup -S www-data 2>/dev/null; \
      	adduser -D -S -G www-data www-data 2>/dev/null; \
  		chown www-data:www-data /run/php-fpm; \
		php-fpm -F"

Giải thích các Tag trong adduserTag

> -D Don't assign a password

> -S System userTạo một User hệ thống.
 
> -G GroupChỉ định User này phải thuộc về Group nào ngay khi tạo.
 
exec php-fpm -F

Dùng tham số init: true (An toàn nhất cho Zombie)
(thường là tini) làm PID 1.