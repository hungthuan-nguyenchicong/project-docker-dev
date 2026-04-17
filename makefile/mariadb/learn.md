1. Tạo một network mới (nếu chưa có):

Bash
docker network create my-app-network
2. Kết nối container MariaDB vào network này:

Bash
docker network connect my-app-network mariadb-alpine-ncc
3. Kết nối container PHP vào network này:

Bash
docker network connect my-app-network php-alpine-ncc

# test
docker network create db-network

docker network connect db-network mariadb-alpine-ncc

docker network connect db-network php-alpine-ncc

> Bây giờ bạn quay lại Adminer và nhập lại ô Server là: mariadb-alpine-ncc


# Cập nhật chính sách restart cho MariaDB
docker update --restart always mariadb-alpine-ncc

# Cập nhật cho các container khác
docker update --restart always php-alpine-ncc
docker update --restart always nginx-alpine-ncc

# Sau đó khởi động lại tất cả
docker start mariadb-alpine-ncc php-alpine-ncc nginx-alpine-ncc

