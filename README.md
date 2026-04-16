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