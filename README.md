# apk add
apk add make

```Makefile
target_a:
	@echo "Dang chay Target A"

target_b: target_a
	@echo "Dang chay Target B sau khi A xong"
```

```Makefile
install:
	@echo "Bat dau qua trinh cai dat..."
	$(MAKE) build
	$(MAKE) cleanup
	@echo "Cai dat hoan tat!"

build:
	@echo "Dang compile code..."

cleanup:
	@echo "Dang don dep file tam..."
```
docker network ls

docker network inspect db-network

--restart always \

php -d memory_limit=512M /usr/local/bin/wp core download --path=wp-app

--network db-network \

--network host

--allow-root

docker exec -u root $(CONTAINER_NAME) sh -c "\

wp server --host=0.0.0.0 --port=8080