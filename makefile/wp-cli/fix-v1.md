docker exec -it wp-cli-alpine-ncc sh

apk add curl php-phar php-curl php-mysqli mariadb-client php-mbstring

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

php wp-cli.phar --info

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp

wp --info


# https://make.wordpress.org/cli/handbook/guides/quick-start/#practical-examples

wp core download --path=wp-app

## fix 512
php -d memory_limit=512M /usr/local/bin/wp core download --path=wp-app

cd wp-app

wp config create --dbname=wpclidemo --dbuser=root --prompt=dbpass

wp config create --dbname=test --dbuser=test --dbpass=123456

## fix con dd
docker network connect db-network wp-cli-alpine-ncc

--dbhost=mariadb-alpine-ncc

wp config create --dbname=test --dbuser=test --dbpass=123456

wp config create --dbname=test --dbuser=test --dbpass=123456 --dbhost=mariadb-alpine-ncc
## fix mariadb-client
mariadb-client

wp db create
## fix mbstring
php-mbstring
wp core install --url=localhost--title="WP-CLI" --admin_user=test --admin_password=test --admin_email=info@wp-cli.org

# fix port

dev --url=localhost:8080

wp server --host=0.0.0.0 --port=8080

--network db-network \
	--restart always \
	-p $(WP_CLI_EXPOSE):8080 \