# Biến số (Variables) để dễ quản lý
COMPOSE_FILE = project-test/adminer/docker-compose.yml
PROJECT_NAME = ncc-adminer-stack

# Mặc định khi gõ 'make' sẽ hiển thị hướng dẫn
.DEFAULT_GOAL := help

help:
	@echo "--- NCC DOCKER MANAGEMENT ---"
	@echo "make build    : Build lại toàn bộ images"
	@echo "make up       : Khởi động hệ thống (dưới nền)"
	@echo "make down     : Dừng và xóa container"
	@echo "make logs     : Xem log thời gian thực"
	@echo "make ps       : Kiểm tra trạng thái và PID"
	@echo "make clean    : Dọn dẹp rác hệ thống Docker"

# 1. Quản lý vòng đời (Lifecycle)
build:
	docker compose -f $(COMPOSE_FILE) build --no-cache

up:
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d

down:
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down

# 2. Kiểm tra & Giám sát (Monitoring)
ps:
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}"
	@echo ""
	@echo "--- Process Tree (Adminer) ---"
	docker exec -it adminer-alpine-ncc ps aux

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# 3. Bảo trì (Maintenance)
clean:
	docker system prune -f
	@echo "Dọn dẹp hoàn tất!"

# 4. Truy cập nhanh (Quick Access)
shell-php:
	docker exec -it adminer-alpine-ncc sh

shell-db:
	docker exec -it mariadb-alpine-ncc sh